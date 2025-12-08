import 'dart:convert';
import '../services/api_service.dart';
import '../models/wheel.dart';

class WheelRepository {
  
  // Save wheel result
  static Future<void> saveWheelResult({
    required String winnerId,
    required String winnerName, 
    required int classId,
  }) async {
    try {
      final response = await ApiService.post('/wheels', {
        'winner_id': winnerId,
        'winner_name': winnerName,
        'classes_id': classId,
      });
      
      if (response.statusCode != 201) {
        throw Exception('Failed to save wheel result');
      }
    } catch (e) {
      print('Save wheel result error: $e');
      throw Exception('Failed to save wheel result: $e');
    }
  }

  // Get all wheel results
  static Future<List<WheelModel>> getWheels() async {
    try {
      final response = await ApiService.get('/wheels');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> wheelsData = data['data'];
          return wheelsData.map((json) => WheelModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Get wheels error: $e');
      return [];
    }
  }

  // Get wheels by class ID
  static Future<List<WheelModel>> getWheelsByClass(int classId) async {
    try {
      final response = await ApiService.get('/wheels');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> wheelsData = data['data'];
          final allWheels = wheelsData.map((json) => WheelModel.fromJson(json)).toList();
          
          // Filter by class ID
          return allWheels.where((wheel) => wheel.classesId == classId).toList();
        }
      }
      return [];
    } catch (e) {
      print('Get wheels by class error: $e');
      return [];
    }
  }

  // Get wheel by ID
  static Future<WheelModel?> getWheelById(int wheelId) async {
    try {
      final response = await ApiService.get('/wheels/$wheelId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return WheelModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Get wheel by ID error: $e');
      return null;
    }
  }

  // Delete wheel result
  static Future<bool> deleteWheelResult(int wheelId) async {
    try {
      final response = await ApiService.delete('/wheels/$wheelId');
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Delete wheel result error: $e');
      return false;
    }
  }
}