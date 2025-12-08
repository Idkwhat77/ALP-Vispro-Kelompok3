import 'dart:convert';
import '../services/api_service.dart';
import '../models/teacher.dart';

class AuthRepository {
  
  // Teacher login for admin panel
  static Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await ApiService.post('/admin/login', {
        'email': email,
        'password': password,
      }, useAuth: false);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(data);
        
        // Save token for future requests
        await ApiService.saveAuthToken(loginResponse.token);
        
        return loginResponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Get current authenticated user
  static Future<Teacher?> getCurrentUser() async {
    try {
      final response = await ApiService.get('/admin/me', useAuth: true);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Teacher.fromJson(data['teacher']);
        }
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }

  // Logout
  static Future<bool> logout() async {
    try {
      final response = await ApiService.post('/admin/logout', {}, useAuth: true);
      
      // Remove token regardless of response
      await ApiService.removeAuthToken();
      
      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      await ApiService.removeAuthToken();
      return false;
    }
  }
}