import 'dart:convert';
import '../services/api_service.dart';
import '../models/student.dart';

class StudentRepository {
  
  // Get all students
  static Future<List<StudentModel>> getStudents() async {
    try {
      final response = await ApiService.get('/students', useAuth: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> studentsData = data['data'];
          return studentsData.map((json) => StudentModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Get students error: $e');
      return [];
    }
  }

  // Get students by class ID
  static Future<List<StudentModel>> getStudentsByClass(int classId) async {
    return getStudentsByClassId(classId);
  }

  // Get students by class ID (uses dedicated endpoint for all students in a class)
  static Future<List<StudentModel>> getStudentsByClassId(int classId) async {
    try {
      // Use the dedicated endpoint that returns all students for a class
      final response = await ApiService.get('/students/by-class/$classId', useAuth: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> studentsData = data['data'];
          return studentsData.map((json) => StudentModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Get students by class error: $e');
      return [];
    }
  }

  // Create new student
  static Future<StudentModel?> createStudent(String studentName, int classId) async {
    try {
      final response = await ApiService.post('/students', {
        'student_name': studentName,
        'classes_id': classId,
      }, useAuth: true);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return StudentModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Create student error: $e');
      return null;
    }
  }

  // Update student
  static Future<StudentModel?> updateStudent(int studentId, String studentName, int classId) async {
    try {
      final response = await ApiService.put('/students/$studentId', {
        'student_name': studentName,
        'classes_id': classId,
      }, useAuth: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return StudentModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Update student error: $e');
      return null;
    }
  }

  // Delete student
  static Future<bool> deleteStudent(int studentId) async {
    try {
      final response = await ApiService.delete('/students/$studentId', useAuth: true);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete student error: $e');
      return false;
    }
  }
}