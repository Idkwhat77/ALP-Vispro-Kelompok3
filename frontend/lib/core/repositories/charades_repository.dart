import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import '../models/charades_theme.dart';
import '../models/charades_word.dart';

class CharadesRepository {
  // Get all charades themes
  static Future<List<CharadesTheme>> getThemes() async {
    try {
      final response = await ApiService.get('/charades-themes', useAuth: true);
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> themes = data['data'];
          return themes.map((json) => CharadesTheme.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e, stack) {
      debugPrint('❌ CHARADES API ERROR: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  // Get words by theme
  static Future<List<CharadesWord>> getWordsByTheme(int themeId) async {
    try {
      final response = await ApiService.get('/charades-words', useAuth: true);

      debugPrint('WORDS STATUS: ${response.statusCode}');
      debugPrint('WORDS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final List<dynamic> allWords = data['data'];

          // 🎯 FILTER BY THEME IN FLUTTER
          return allWords
              .map((json) => CharadesWord.fromJson(json))
              .where((w) => w.themeId == themeId)
              .toList();
        }
      }

      return [];
    } catch (e, stack) {
      debugPrint('❌ WORD FETCH ERROR: $e');
      debugPrintStack(stackTrace: stack);
      return [];
    }
  }
}
