import 'dart:convert';
import 'package:http/http.dart' as http;

class GameSessionRepository {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Map<String, dynamic>>> fetchSessions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/game-sessions'));

      if (response.statusCode != 200) {
        print("HTTP error: ${response.statusCode}");
        return [];
      }

      final decoded = jsonDecode(response.body);

      if (decoded == null || decoded['data'] == null) {
        print("JSON data null or missing 'data'");
        return [];
      }

      final List rawList = decoded['data'];

      final List<Map<String, dynamic>> safeList = [];

      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          safeList.add(item);
        }
      }

      return safeList;
    } catch (e) {
      print("Fetch error: $e");
      return [];
    }
  }
}
