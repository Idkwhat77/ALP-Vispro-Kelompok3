import 'package:frontend/core/models/charades_theme.dart';
import 'package:frontend/core/models/charades_word.dart';

enum CharadesResult { correct, skipped }

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
  final List<CharadesWord> words;
  final CharadesResult? lastResult;

  CharadesRunning(
    this.currentWord,
    this.score,
    this.remaining, {
    required this.words,
    this.lastResult,
  });
}

class CharadesGameOver extends CharadesState {
  final int score;
  CharadesGameOver(this.score);
}

class CharadesError extends CharadesState {
  final String message;
  CharadesError(this.message);
}
