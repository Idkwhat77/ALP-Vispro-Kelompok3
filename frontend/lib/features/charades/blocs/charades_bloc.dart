import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:frontend/core/models/charades_word.dart';
import 'package:frontend/core/repositories/charades_repository.dart';
import 'package:frontend/core/services/api_service.dart';

import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;

  StreamSubscription? _gyroSub;
  StreamSubscription? _accelSub;

  double _smoothedGyroY = 0;
  double _smoothedAccelY = 0;

  bool _onCooldown = false;

  // These IDs should come from your app's state
  int _classId = 1;
  int _teacherId = 1;

  CharadesBloc() : super(CharadesInitial()) {
    on<LoadThemes>(_onLoadThemes);
    on<SelectTheme>(_onSelectTheme);
    on<StartGame>(_onStartGame);
    on<TiltDetected>(_onTiltDetected);
    on<RestartGame>(_onRestart);
  }

  Future<void> _onLoadThemes(
    LoadThemes event,
    Emitter<CharadesState> emit,
  ) async {
    emit(CharadesLoadingThemes());
    final themes = await CharadesRepository.getThemes();
    emit(CharadesThemesLoaded(themes));
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
        ),
      );
      _startSensorListeners();
    } catch (e) {
      emit(CharadesError(e.toString()));
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
      _index++;

      if (_index >= _words.length) {
        _stopSensorListeners();
        emit(CharadesGameOver(_score));

        // Send result to backend
        await _saveGameSession();
      } else {
        emit(
          CharadesRunning(
            _words[_index].word,
            _score,
            _words.length - _index - 1,
          ),
        );
      }
    } else if (event.direction == 'backward') {
      _index++;
      if (_index >= _words.length) {
        _stopSensorListeners();
        emit(CharadesGameOver(_score));
        await _saveGameSession();
      } else {
        emit(
          CharadesRunning(
            _words[_index].word,
            _score,
            _words.length - _index - 1,
          ),
        );
      }
    }
  }

  Future<void> _onRestart(
    RestartGame event,
    Emitter<CharadesState> emit,
  ) async {
    add(LoadThemes());
  }

  void _startSensorListeners() {
    _gyroSub?.cancel();
    _accelSub?.cancel();

    _smoothedGyroY = 0;
    _smoothedAccelY = 0;
    _onCooldown = false;

    _gyroSub = gyroscopeEvents.listen((g) {
      _smoothedGyroY = (_smoothedGyroY * 0.7) + (g.y * 0.3);
    });

    _accelSub = accelerometerEvents.listen((a) {
      _smoothedAccelY = (_smoothedAccelY * 0.8) + (a.y * 0.2);
      _evaluateTilt();
    });
  }

  void _stopSensorListeners() {
    _gyroSub?.cancel();
    _gyroSub = null;
    _accelSub?.cancel();
    _accelSub = null;
  }

  void _evaluateTilt() {
    if (_onCooldown) return;

    final forward = _smoothedGyroY > 1.2 && _smoothedAccelY > 5.0;
    final backward = _smoothedGyroY < -1.2 && _smoothedAccelY < -5.0;

    if (forward) add(TiltDetected('forward'));
    if (backward) add(TiltDetected('backward'));
  }

  void _startCooldown() {
    _onCooldown = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => _onCooldown = false,
    );
  }

  // ------------------ SAVE GAME SESSION ------------------
  Future<void> _saveGameSession() async {
    if (state is! CharadesRunning && _words.isEmpty) return;

    try {
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
    _stopSensorListeners();
    return super.close();
  }
}
