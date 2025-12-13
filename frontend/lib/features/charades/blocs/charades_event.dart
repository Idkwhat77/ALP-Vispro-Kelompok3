abstract class CharadesEvent {}

class LoadThemes extends CharadesEvent {}

class SelectTheme extends CharadesEvent {
  final int themeId;
  final String themeName;
  SelectTheme(this.themeId, this.themeName);
}

class StartGame extends CharadesEvent {}

class TiltDetected extends CharadesEvent {
  final String direction;
  TiltDetected(this.direction);
}

class RestartGame extends CharadesEvent {}
