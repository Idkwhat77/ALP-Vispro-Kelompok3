import 'package:frontend/core/models/charades_theme.dart';
import 'package:frontend/core/models/charades_word.dart';

// ─────────────────────────────────────────────
// RESULT SIGNAL FOR UI FEEDBACK
// ─────────────────────────────────────────────

enum CharadesResult { correct, skipped }

// ─────────────────────────────────────────────
// BASE STATE
// ─────────────────────────────────────────────

abstract class CharadesState {}

// Initial
class CharadesInitial extends CharadesState {}

// Loading themes
class CharadesLoadingThemes extends CharadesState {}

// Themes loaded
class CharadesThemesLoaded extends CharadesState {
  final List<CharadesTheme> themes;
  CharadesThemesLoaded(this.themes);
}

// Theme selected
class CharadesThemeSelected extends CharadesState {
  final int themeId;
  final String themeName;
  CharadesThemeSelected(this.themeId, this.themeName);
}

// Loading words
class CharadesLoadingWords extends CharadesState {}

// ─────────────────────────────────────────────
// GAME RUNNING
// ─────────────────────────────────────────────

class CharadesRunning extends CharadesState {
  final String currentWord;
  final int score;
  final int remaining;
  final List<CharadesWord> words;

  /// NEW: tells UI what just happened
  final CharadesResult? lastResult;

  CharadesRunning(
    this.currentWord,
    this.score,
    this.remaining, {
    required this.words,
    this.lastResult,
  });

  CharadesRunning copyWith({
    String? currentWord,
    int? score,
    int? remaining,
    List<CharadesWord>? words,
    CharadesResult? lastResult,
  }) {
    return CharadesRunning(
      currentWord ?? this.currentWord,
      score ?? this.score,
      remaining ?? this.remaining,
      words: words ?? this.words,
      lastResult: lastResult,
    );
  }
}

// ─────────────────────────────────────────────
// GAME OVER
// ─────────────────────────────────────────────

class CharadesGameOver extends CharadesState {
  final int score;
  CharadesGameOver(this.score);
}

// Error
class CharadesError extends CharadesState {
  final String message;
  CharadesError(this.message);
}
