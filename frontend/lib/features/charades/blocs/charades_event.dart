abstract class CharadesEvent {}

/// ---------------- UI EVENTS ----------------

class LoadThemes extends CharadesEvent {}

class SelectTheme extends CharadesEvent {
  final int themeId;
  final String themeName;

  SelectTheme(this.themeId, this.themeName);
}

class StartGame extends CharadesEvent {}

class RestartGame extends CharadesEvent {}

/// ---------------- TIMER EVENT ----------------

class WordTimeExpired extends CharadesEvent {}

/// ---------------- SENSOR EVENTS ----------------

enum PhoneTilt {
  neutral,
  towardFace, // correct
  awayFromFace, // skip
}

class TiltUpdated extends CharadesEvent {
  final PhoneTilt tilt;
  TiltUpdated(this.tilt);
}
