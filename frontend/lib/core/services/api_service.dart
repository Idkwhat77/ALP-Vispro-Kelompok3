import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String publicUrl = 'http://10.0.2.2:8000/api/public';

  // Get auth token from shared preferences
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save auth token to shared preferences
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove auth token
  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Generic GET request
  static Future<http.Response> get(String endpoint, {bool useAuth = false}) async {
    final url = useAuth ? '$baseUrl$endpoint' : '$publicUrl$endpoint';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return await http.get(Uri.parse(url), headers: headers);
  }

  // Generic POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool useAuth = false}) async {
    final url = useAuth ? '$baseUrl$endpoint' : '$publicUrl$endpoint';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  // Generic PUT request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body, {bool useAuth = false}) async {
    final url = useAuth ? '$baseUrl$endpoint' : '$publicUrl$endpoint';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  // Generic DELETE request
  static Future<http.Response> delete(String endpoint, {bool useAuth = false}) async {
    final url = useAuth ? '$baseUrl$endpoint' : '$publicUrl$endpoint';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return await http.delete(Uri.parse(url), headers: headers);
  }
}