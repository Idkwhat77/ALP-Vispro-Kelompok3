import 'dart:convert';
import 'package:frontend/core/services/api_service.dart';
import '../../../../core/models/game_session.dart';

class HistoryService {
  static Future<List<GameSession>> fetchSessions() async {
    try {
      final response = await ApiService.get('/game-sessions');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((e) => GameSession.fromJson(e)).toList();
      } else {
        print('Failed to load history: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }
}
