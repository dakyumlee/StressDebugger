import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/stress_log.dart';

class ApiService {
  static String? _token;

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<User> register(String username, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickname': nickname,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      await saveToken(user.token);
      return user;
    } else {
      throw Exception('Failed to register');
    }
  }

  static Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      await saveToken(user.token);
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<StressLog> createLog(String text) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/logs'),
      headers: _getHeaders(),
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return StressLog.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create log');
    }
  }

  static Future<List<StressLog>> getLogs() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/logs'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => StressLog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load logs');
    }
  }

  static Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/logs/stats'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }
}
