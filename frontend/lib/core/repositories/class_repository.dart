import 'dart:convert';
import '../services/api_service.dart';
import '../models/class.dart';

class ClassRepository {
  
  // Get all classes
  static Future<List<ClassModel>> getClasses() async {
    return getAllClasses();
  }

  // Get all classes (alias for compatibility)
  static Future<List<ClassModel>> getAllClasses() async {
    try {
      final response = await ApiService.get('/classes');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> classesData = data['data'];
          return classesData.map((json) => ClassModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Get classes error: $e');
      return [];
    }
  }

  // Get class by ID
  static Future<ClassModel?> getClassById(int classId) async {
    try {
      final response = await ApiService.get('/classes/$classId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return ClassModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Get class by ID error: $e');
      return null;
    }
  }

  // Create new class
  static Future<ClassModel?> createClass(String className, int teacherId) async {
    try {
      final response = await ApiService.post('/classes', {
        'class_name': className,
        'teacher_id': teacherId,
      });

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return ClassModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Create class error: $e');
      return null;
    }
  }

  // Update class
  static Future<ClassModel?> updateClass(int classId, String className) async {
    try {
      final response = await ApiService.put('/classes/$classId', {
        'class_name': className,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return ClassModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Update class error: $e');
      return null;
    }
  }

  // Delete class
  static Future<bool> deleteClass(int classId) async {
    try {
      final response = await ApiService.delete('/classes/$classId');
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Delete class error: $e');
      return false;
    }
  }
}