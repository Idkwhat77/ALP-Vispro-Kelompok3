import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../core/models/charades_word.dart';
import '../../../core/repositories/charades_repository.dart';
import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  // ───────────────── GAME STATE ─────────────────

  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;

  int? _selectedThemeId;
  String? _selectedThemeName;

  // ───────────────── SENSOR STATE ─────────────────

  StreamSubscription? _accelSub;

  PhoneTilt _lastTilt = PhoneTilt.neutral;
  bool _locked = false;

  double _lastZ = 0;
  DateTime _lastTime = DateTime.now();

  // ───────────────── TUNING CONSTANTS ─────────────────

  static const double tiltThreshold = 6.0;
  static const double neutralThreshold = 2.0;
  static const double speedThreshold = 0.015;
  static const int cooldownMs = 600;

  CharadesBloc() : super(CharadesInitial()) {
    on<LoadThemes>(_onLoadThemes);
    on<SelectTheme>(_onSelectTheme);
    on<StartGame>(_onStartGame);
    on<TiltUpdated>(_onTiltUpdated);
    on<RestartGame>(_onRestart);
  }

  // ───────────────── EVENTS ─────────────────

  Future<void> _onLoadThemes(
    LoadThemes event,
    Emitter<CharadesState> emit,
  ) async {
    emit(CharadesLoadingThemes());

    try {
      final themes = await CharadesRepository.getThemes();
      emit(CharadesThemesLoaded(themes));
    } catch (e) {
      emit(CharadesError(e.toString()));
    }
  }

  void _onSelectTheme(SelectTheme event, Emitter<CharadesState> emit) {
    _selectedThemeId = event.themeId;
    _selectedThemeName = event.themeName;

    emit(CharadesThemeSelected(event.themeId, event.themeName));
  }

  Future<void> _onStartGame(
    StartGame event,
    Emitter<CharadesState> emit,
  ) async {
    if (_selectedThemeId == null) {
      emit(CharadesError('Theme not selected'));
      return;
    }

    emit(CharadesLoadingWords());

    try {
      _words = await CharadesRepository.getWordsByTheme(_selectedThemeId!);

      if (_words.isEmpty) {
        emit(CharadesError('No words found'));
        return;
      }

      _index = 0;
      _score = 0;
      _locked = false;
      _lastTilt = PhoneTilt.neutral;
      _lastZ = 0;
      _lastTime = DateTime.now();

      emit(
        CharadesRunning(
          _words[_index].word,
          _score,
          _words.length - 1,
          words: const [],
        ),
      );

      _startSensorListener();
    } catch (e) {
      emit(CharadesError(e.toString()));
    }
  }

  void _onTiltUpdated(TiltUpdated event, Emitter<CharadesState> emit) {
    if (state is! CharadesRunning) return;
    if (_locked) return;
    if (event.tilt == PhoneTilt.neutral) return;

    _locked = true;

    final result = event.tilt == PhoneTilt.towardFace
        ? CharadesResult.correct
        : CharadesResult.skipped;

    if (result == CharadesResult.correct) {
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
        words: const [],
        lastResult: result,
      ),
    );

    Future.delayed(
      const Duration(milliseconds: cooldownMs),
      () => _locked = false,
    );
  }

  void _onRestart(RestartGame event, Emitter<CharadesState> emit) {
    _stopSensors();

    _words = [];
    _index = 0;
    _score = 0;
    _selectedThemeId = null;
    _selectedThemeName = null;

    add(LoadThemes());
  }

  // ───────────────── SENSOR LOGIC ─────────────────

  void _startSensorListener() {
    _accelSub?.cancel();

    _accelSub = accelerometerEvents.listen((event) {
      final now = DateTime.now();
      final dt = now.difference(_lastTime).inMilliseconds;
      final dz = event.z - _lastZ;

      final speed = dz.abs() / math.max(dt, 1);

      _lastZ = event.z;
      _lastTime = now;

      // Re-arm when neutral
      if (event.z.abs() < neutralThreshold) {
        _lastTilt = PhoneTilt.neutral;
        return;
      }

      if (_locked || speed < speedThreshold) return;

      if (event.z > tiltThreshold) {
        add(TiltUpdated(PhoneTilt.towardFace));
      } else if (event.z < -tiltThreshold) {
        add(TiltUpdated(PhoneTilt.awayFromFace));
      }
    });
  }

  void _stopSensors() {
    _accelSub?.cancel();
    _accelSub = null;
    _locked = false;
    _lastTilt = PhoneTilt.neutral;
  }

  @override
  Future<void> close() {
    _stopSensors();
    return super.close();
  }
}
