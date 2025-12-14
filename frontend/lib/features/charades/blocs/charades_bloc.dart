import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/models/charades_word.dart';
import 'package:frontend/core/repositories/charades_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:frontend/core/services/api_service.dart';

import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  // Game state
  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;

  // Sensors
  StreamSubscription? _accelSub;

  // smoothing
  double _smoothedAccelX = 0;

  // cooldown
  bool _onCooldown = false;

  // IDs for backend
  final int _classId = 1;
  final int _teacherId = 1;

  CharadesBloc() : super(CharadesInitial()) {
    on<LoadThemes>(_onLoadThemes);
    on<SelectTheme>(_onSelectTheme);
    on<StartGame>(_onStartGame);
    on<TiltDetected>(_onTiltDetected);
    on<RestartGame>(_onRestart);
  }

  // ---------------- EVENTS ----------------
  Future<void> _onLoadThemes(
    LoadThemes event,
    Emitter<CharadesState> emit,
  ) async {
    emit(CharadesLoadingThemes());
    try {
      final themes = await CharadesRepository.getThemes();
      emit(CharadesThemesLoaded(themes));
    } catch (e) {
      emit(CharadesError('Failed to load themes: $e'));
    }
  }

  Future<void> _onSelectTheme(
    SelectTheme event,
    Emitter<CharadesState> emit,
  ) async {
    emit(CharadesThemeSelected(event.themeId, event.themeName));
  }

  Future<void> _onStartGame(
    StartGame event,
    Emitter<CharadesState> emit,
  ) async {
    if (state is! CharadesThemeSelected) {
      emit(CharadesError('Theme not selected'));
      return;
    }

    final themeState = state as CharadesThemeSelected;
    emit(CharadesLoadingWords());

    try {
      _words = (await CharadesRepository.getWordsByTheme(
        themeState.themeId,
      )).cast<CharadesWord>();

      if (_words.isEmpty) {
        emit(CharadesError('No words found'));
        return;
      }

      _index = 0;
      _score = 0;

      emit(
        CharadesRunning(
          _words[_index].word,
          _score,
          _words.length - _index - 1,
          words: [],
        ),
      );

      _startSensorListener();
    } catch (e) {
      emit(CharadesError('Failed to load words: $e'));
    }
  }

  Future<void> _onTiltDetected(
    TiltDetected event,
    Emitter<CharadesState> emit,
  ) async {
    if (_onCooldown || state is! CharadesRunning) return;
    _startCooldown();

    if (event.direction == 'forward') {
      _score++;
    }
    _index++;

    if (_index >= _words.length) {
      _stopSensorListener();
      emit(CharadesGameOver(_score));
      await _saveGameSession();
    } else {
      emit(
        CharadesRunning(
          _words[_index].word,
          _score,
          _words.length - _index - 1,
          words: [],
        ),
      );
    }
  }

  Future<void> _onRestart(
    RestartGame event,
    Emitter<CharadesState> emit,
  ) async {
    add(LoadThemes());
  }

  // ---------------- SENSOR ----------------
  void _startSensorListener() {
    _accelSub?.cancel();
    _smoothedAccelX = 0;
    _onCooldown = false;

    _accelSub = accelerometerEvents.listen((a) {
      _smoothedAccelX = (_smoothedAccelX * 0.8) + (a.x * 0.2); // smooth
      _evaluateTilt();
    });
  }

  void _stopSensorListener() {
    _accelSub?.cancel();
    _accelSub = null;
  }

  void _evaluateTilt() {
    if (_onCooldown) return;

    const threshold = 5.0;

    if (_smoothedAccelX > threshold) {
      add(TiltDetected('forward')); // right tilt = correct guess
    } else if (_smoothedAccelX < -threshold) {
      add(TiltDetected('backward')); // left tilt = skip
    }
  }

  void _startCooldown() {
    _onCooldown = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _onCooldown = false;
    });
  }

  // ---------------- SAVE GAME SESSION ----------------
  Future<void> _saveGameSession() async {
    if (_words.isEmpty) return;

    int themeId = 1;
    if (state is CharadesThemeSelected) {
      themeId = (state as CharadesThemeSelected).themeId;
    }

    final body = {
      'class_id': _classId,
      'teacher_id': _teacherId,
      'charades_theme_id': themeId,
      'played_at': DateTime.now().toIso8601String(),
      'total_guess_correct': _score,
      'total_guess_skipped': _words.length - _score,
    };

    try {
      final response = await ApiService.post('/game-sessions', body);
      if (response.statusCode == 201) {
        print('✅ Game session saved successfully');
      } else {
        print('⚠️ Failed to save game session: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Error sending game session: $e');
    }
  }

  @override
  Future<void> close() {
    _stopSensorListener();
    return super.close();
  }
}
