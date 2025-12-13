import 'package:frontend/core/models/charades_theme.dart';

abstract class CharadesState {}

class CharadesInitial extends CharadesState {}

class CharadesLoadingThemes extends CharadesState {}

class CharadesThemesLoaded extends CharadesState {
  final List<CharadesTheme> themes;
  CharadesThemesLoaded(this.themes);
}

class CharadesThemeSelected extends CharadesState {
  final int themeId;
  final String themeName;
  CharadesThemeSelected(this.themeId, this.themeName);
}

class CharadesLoadingWords extends CharadesState {}

class CharadesRunning extends CharadesState {
  final String currentWord;
  final int score;
  final int remaining;
  CharadesRunning(this.currentWord, this.score, this.remaining);
}

class CharadesGameOver extends CharadesState {
  final int score;
  CharadesGameOver(this.score);
}

class CharadesError extends CharadesState {
  final String message;
  CharadesError(this.message);
}
