class ClassGenerator {
  // returns list of class keys (7A..9C)
  static List<String> get classList =>
      ['7A', '7B', '7C', '8A', '8B', '8C', '9A', '9B', '9C'];

  // generate mock student names for a given class key
  static List<String> makeNames(String prefix, [int count = 30]) {
    return List<String>.generate(count, (i) => '$prefix ${i + 1}');
  }

  // convenience map of all classes -> names (lazy created on demand)
  static Map<String, List<String>> buildAll({int perClass = 30}) {
    final Map<String, List<String>> m = {};
    for (final k in classList) {
      m[k] = makeNames('$k - Siswa', perClass);
    }
    return m;
  }
}
