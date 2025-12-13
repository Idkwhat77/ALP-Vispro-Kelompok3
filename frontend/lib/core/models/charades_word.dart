// TODO Implement this library.
class CharadesWord {
  final int id;
  final int themeId;
  final String word;

  CharadesWord({required this.id, required this.themeId, required this.word});

  factory CharadesWord.fromJson(Map<String, dynamic> json) {
    return CharadesWord(
      id: json['id_charades_words'],
      themeId: json['charades_themes_id'],
      word: json['word'],
    );
  }
}
