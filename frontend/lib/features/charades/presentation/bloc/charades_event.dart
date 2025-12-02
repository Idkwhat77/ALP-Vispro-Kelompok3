abstract class CharadesEvent {}

class StartGame extends CharadesEvent {}

class TiltDetected extends CharadesEvent {
  final String direction;
  TiltDetected(this.direction);
}

class NextWord extends CharadesEvent {}
