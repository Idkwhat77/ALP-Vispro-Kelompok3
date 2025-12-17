import 'dart:convert';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;

class GameSessionRepository {
  static Future<List<Map<String, dynamic>>> fetchSessions() async {
    try {
      // Use ApiService with auth to fetch game sessions
      final response = await ApiService.get('/game-sessions', useAuth: true);

      if (response.statusCode != 200) {
        print("HTTP error: ${response.statusCode}");
        print("Response body: ${response.body}");
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

  static Future<bool> createGameSession({
    required int classId,
    required int teacherId,
    required int charadesThemeId,
    required int totalCorrect,
    required int totalSkipped,
  }) async {
    try {
      // Use ApiService with auth to create game session
      final response = await ApiService.post(
        '/game-sessions',
        {
          'class_id': classId,
          'teacher_id': teacherId,
          'charades_theme_id': charadesThemeId,
          'played_at': DateTime.now().toIso8601String(),
          'total_guess_correct': totalCorrect,
          'total_guess_skipped': totalSkipped,
        },
        useAuth: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Game session saved successfully");
        return true;
      } else {
        print("Failed to save game session: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating game session: $e");
      return false;
    }
  }
}
 