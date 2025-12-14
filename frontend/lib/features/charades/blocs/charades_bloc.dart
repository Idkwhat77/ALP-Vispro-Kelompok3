import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/models/charades_word.dart';
import '../../../core/repositories/charades_repository.dart';
import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  // ---------------- GAME STATE ----------------

  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;

  // ---------------- SENSOR ----------------

  StreamSubscription? _accelSub;
  bool _cooldown = false;
  PhoneTilt _lastTilt = PhoneTilt.neutral;

  CharadesBloc() : super(CharadesInitial()) {
    on<LoadThemes>(_onLoadThemes);
    on<SelectTheme>(_onSelectTheme);
    on<StartGame>(_onStartGame);
    on<TiltUpdated>(_onTiltUpdated);
    on<RestartGame>(_onRestart);
  }

  // ================= EVENTS =================

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

    final theme = state as CharadesThemeSelected;
    emit(CharadesLoadingWords());

    try {
      _words = await CharadesRepository.getWordsByTheme(theme.themeId);

      if (_words.isEmpty) {
        emit(CharadesError('No words found'));
        return;
      }

      _index = 0;
      _score = 0;
      _lastTilt = PhoneTilt.neutral;

      emit(
        CharadesRunning(
          _words[_index].word,
          _score,
          _words.length - 1,
          words: [],
        ),
      );

      _startSensorListener();
    } catch (e) {
      emit(CharadesError(e.toString()));
    }
  }

  void _onTiltUpdated(TiltUpdated event, Emitter<CharadesState> emit) {
    if (_cooldown || state is! CharadesRunning) return;

    // Prevent instant firing when entering landscape
    if (event.tilt == PhoneTilt.neutral || event.tilt == _lastTilt) return;

    _lastTilt = event.tilt;
    _cooldown = true;

    if (event.tilt == PhoneTilt.towardFace) {
      _score++;
    }

    _index++;

    if (_index >= _words.length) {
      _stopSensors();
      emit(CharadesGameOver(_score));
      return;
    }

    emit(
      CharadesRunning(
        _words[_index].word,
        _score,
        _words.length - _index - 1,
        words: [],
      ),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      _cooldown = false;
    });
  }

  void _onRestart(RestartGame event, Emitter<CharadesState> emit) {
    _stopSensors();
    add(LoadThemes());
  }

  // ================= SENSOR LOGIC =================

  void _startSensorListener() {
    _accelSub?.cancel();

    _accelSub = accelerometerEvents.listen((event) async {
      final orientation = await SystemChrome.latestStyle == null
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeLeft;

      final double x = event.x;
      final double y = event.y;

      // Normalize tilt depending on landscape direction
      double forwardValue;

      if (orientation == DeviceOrientation.landscapeLeft) {
        forwardValue = -x;
      } else {
        forwardValue = x;
      }

      PhoneTilt tilt = PhoneTilt.neutral;

      if (forwardValue > 6.0) {
        tilt = PhoneTilt.towardFace;
      } else if (forwardValue < -6.0) {
        tilt = PhoneTilt.awayFromFace;
      }

      add(TiltUpdated(tilt));
    });
  }

  void _stopSensors() {
    _accelSub?.cancel();
    _accelSub = null;
    _cooldown = false;
    _lastTilt = PhoneTilt.neutral;
  }

  @override
  Future<void> close() {
    _stopSensors();
    return super.close();
  }
}
