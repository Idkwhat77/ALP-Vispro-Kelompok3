import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/charades_word.dart';
import '../../../core/repositories/charades_repository.dart';
import '../../../core/repositories/game_session_repository.dart';
import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  // ───────────────── GAME STATE ─────────────────

  List<CharadesWord> _words = [];
  int _index = 0;
  int _score = 0;
  int _skipped = 0;

  int? _selectedThemeId;

  // ───────────────── TIMER STATE ─────────────────

  Timer? _roundTimer;
  static const Duration roundDuration = Duration(seconds: 30);

  // ───────────────── SENSOR STATE ─────────────────

  StreamSubscription? _accelSub;
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
    on<WordTimeExpired>(_onWordTimeExpired);
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
      _skipped = 0;
      _locked = false;
      _lastZ = 0;
      _lastTime = DateTime.now();

      emit(_buildRunningState());

      _startRoundTimer();
      _startSensorListener();
    } catch (e) {
      emit(CharadesError(e.toString()));
    }
  }

  void _onTiltUpdated(TiltUpdated event, Emitter<CharadesState> emit) {
    if (state is! CharadesRunning || _locked) return;

    _locked = true;
    _stopRoundTimer();

    final result = event.tilt == PhoneTilt.towardFace
        ? CharadesResult.correct
        : CharadesResult.skipped;

    if (result == CharadesResult.correct) {
      _score++;
    } else {
      _skipped++;
    }

    _advanceWord(result, emit);

    Future.delayed(
      const Duration(milliseconds: cooldownMs),
      () => _locked = false,
    );
  }

  void _onWordTimeExpired(WordTimeExpired event, Emitter<CharadesState> emit) {
    if (state is! CharadesRunning) return;
    _skipped++;
    _advanceWord(CharadesResult.skipped, emit);
  }

  void _onRestart(RestartGame event, Emitter<CharadesState> emit) {
    _stopSensors();
    _stopRoundTimer();

    _words = [];
    _index = 0;
    _score = 0;
    _skipped = 0;
    _selectedThemeId = null;

    add(LoadThemes());
  }

  // ───────────────── GAME FLOW ─────────────────

  void _advanceWord(CharadesResult result, Emitter<CharadesState> emit) {
    _index++;

    if (_index >= _words.length) {
      _stopSensors();
      _stopRoundTimer();
      _saveGameSession(); // <-- ADD THIS LINE
      emit(CharadesGameOver(_score));
      return;
    }

    emit(
      CharadesRunning(
        _words[_index].word,
        _score,
        _words.length - _index - 1,
        lastResult: result,
      ),
    );

    _startRoundTimer();
  }

  Future<void> _saveGameSession() async {
    if (_selectedThemeId == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final teacherId = prefs.getInt('teacher_id') ?? 1;
      final classId = prefs.getInt('selected_class_id') ?? 1;

      await GameSessionRepository.createGameSession(
        classId: classId,
        teacherId: teacherId,
        charadesThemeId: _selectedThemeId!,
        totalCorrect: _score,
        totalSkipped: _skipped,
      );
    } catch (e) {
      print('Error saving game session: $e');
    }
  }

  CharadesRunning _buildRunningState() {
    return CharadesRunning(
      _words[_index].word,
      _score,
      _words.length - _index - 1,
    );
  }

  // ───────────────── TIMER LOGIC ─────────────────

  void _startRoundTimer() {
    _roundTimer?.cancel();
    _roundTimer = Timer(roundDuration, () {
      add(WordTimeExpired());
    });
  }

  void _stopRoundTimer() {
    _roundTimer?.cancel();
    _roundTimer = null;
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
  }

  @override
  Future<void> close() {
    _stopSensors();
    _stopRoundTimer();
    return super.close();
  }
}
