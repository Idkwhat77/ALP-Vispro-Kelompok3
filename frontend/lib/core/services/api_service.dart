import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Dynamic base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      // IMPORTANT: Replace this IP with your actual machine's IP address
      // Find it by running: ipconfig
      return 'http://192.168.56.1:8000/api'; // e.g., http://192.168.1.100:8000/api
    } else if (Platform.isAndroid) {
      // For Android emulator
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isIOS) {
      // For iOS simulator  
      return 'http://localhost:8000/api';
    } else {
      // For other platforms (desktop)
      return 'http://localhost:8000/api';
    }
  }

  // Alternative URL for when backend runs on 0.0.0.0 and localhost doesn't work
  static String get networkBaseUrl {
    // You need to replace this IP with your actual machine's IP address
    // Run: ipconfig (Windows) or ifconfig (Mac/Linux) to find your IP
    return 'http://192.168.56.1:8000/api'; // Replace with your IP
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> removeAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // GET
  static Future<http.Response> get(
    String endpoint, {
    bool useAuth = false,
  }) async {
    final url = '$baseUrl$endpoint';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.get(Uri.parse(url), headers: headers);
  }

  // POST
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool useAuth = false,
  }) async {
    final url = '$baseUrl$endpoint';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  // PUT
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool useAuth = false,
  }) async {
    final url = '$baseUrl$endpoint';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );
  }

  // DELETE
  static Future<http.Response> delete(
    String endpoint, {
    bool useAuth = false,
  }) async {
    final url = '$baseUrl$endpoint';

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (useAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return http.delete(Uri.parse(url), headers: headers);
  }
}
