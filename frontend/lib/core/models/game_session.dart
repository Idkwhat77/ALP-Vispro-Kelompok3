class GameSession {
  final int id;
  final String themeName;
  final String playedAt;
  final int totalCorrect;
  final int totalSkipped;

  GameSession({
    required this.id,
    required this.themeName,
    required this.playedAt,
    required this.totalCorrect,
    required this.totalSkipped,
  });

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id_game_sessions'],
      themeName: json['charades_theme']['name'] ?? 'Unknown Theme',
      playedAt: json['played_at'],
      totalCorrect: json['total_guess_correct'] ?? 0,
      totalSkipped: json['total_guess_skipped'] ?? 0,
    );
  }
}
