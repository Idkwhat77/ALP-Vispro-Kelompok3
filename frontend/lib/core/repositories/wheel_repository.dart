import 'dart:convert';
import '../services/api_service.dart';
import '../models/wheel.dart';

class WheelRepository {
  
  // Create new wheel entry (save spin result)
  static Future<void> saveWheelResult({
    required String winnerId,
    required String winnerName, 
    required int classId,
  }) async {
    try {
      final response = await ApiService.post(
        '/wheels',
        {
          'winner_id': winnerId,
          'winner_name': winnerName,
          'classes_id': classId,
        },
        useAuth: true,
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to save wheel result');
      }
    } catch (e) {
      throw Exception('Save wheel result error: $e');
    }
  }

  // Get all wheel records
  static Future<List<WheelModel>> getWheels() async {
    try {
      final response = await ApiService.get('/wheels', useAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => WheelModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Filter wheels by class
  static Future<List<WheelModel>> getWheelsByClass(int classId) async {
    final wheels = await getWheels();
    return wheels.where((w) => w.classesId == classId).toList();
  }

  // Get specific wheel entry
  static Future<WheelModel?> getWheelById(int wheelId) async {
    try {
      final response = await ApiService.get('/wheels/$wheelId', useAuth: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WheelModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Delete wheel result
  static Future<bool> deleteWheelResult(int wheelId) async {
    try {
      final response = await ApiService.delete('/wheels/$wheelId', useAuth: true);
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
