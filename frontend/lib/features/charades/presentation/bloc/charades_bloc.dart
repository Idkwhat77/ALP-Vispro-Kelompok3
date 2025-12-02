import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'charades_event.dart';
import 'charades_state.dart';

class CharadesBloc extends Bloc<CharadesEvent, CharadesState> {
  List<String> words = ["Flutter", "BLoC", "Gyroscope"];
  int index = 0;
  int score = 0;

  CharadesBloc() : super(CharadesInitial()) {
    on<StartGame>((event, emit) {
      emit(CharadesRunning(words[index], score));
      _listenGyro();
    });

    on<TiltDetected>((event, emit) {
      if (event.direction == "forward") {
        score++;
        index++;
        if (index >= words.length) {
          emit(CharadesGameOver(score));
        } else {
          emit(CharadesRunning(words[index], score));
        }
      }
    });
  }

  void _listenGyro() {
    gyroscopeEvents.listen((event) {
      if (event.x > 1.0)
        add(TiltDetected("forward"));
      else if (event.x < -1.0)
        add(TiltDetected("backward"));
    });
  }
}
