import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/models/charades_word.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'charades_event.dart';
import 'charades_state.dart';
import '../../../core/repositories/charades_repository.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  // Game state
  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;

  // Sensors
  StreamSubscription? _gyroSub;
  StreamSubscription? _accelSub;

  // smoothing
  double _smoothedGyroY = 0;
  double _smoothedAccelY = 0;

  // cooldown
  bool _onCooldown = false;

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
    print('🔥 LoadThemes event triggered');
    emit(CharadesLoadingThemes());

    final themes = await CharadesRepository.getThemes();
    print('🔥 THEMES COUNT: ${themes.length}');

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

  // ---------------- SENSOR LOGIC ----------------

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
    _accelSub = null;
    _accelSub?.cancel();
    _accelSub = null;
  }

  void _evaluateTilt() {
    if (_onCooldown) return;

    final forward = _smoothedGyroY > 1.2 && _smoothedAccelY > 5.0;
    final backward = _smoothedGyroY < -1.2 && _smoothedAccelY < -5.0;

    if (forward) {
      add(TiltDetected('forward'));
    } else if (backward) {
      add(TiltDetected('backward'));
    }
  }

  void _startCooldown() {
    _onCooldown = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      _onCooldown = false;
    });
  }

  @override
  Future<void> close() {
    _stopSensorListeners();
    return super.close();
  }
}
