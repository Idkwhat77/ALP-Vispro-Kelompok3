// TODO Implement this library.
class CharadesTheme {
  final int id;
  final String name;

  CharadesTheme({required this.id, required this.name});

  factory CharadesTheme.fromJson(Map<String, dynamic> json) {
    return CharadesTheme(id: json['id_charades_themes'], name: json['name']);
  }
}
