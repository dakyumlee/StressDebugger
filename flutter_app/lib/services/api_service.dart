import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://stressdebuggerbackend-production.up.railway.app/api';
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  
  static Future<Map<String, dynamic>> register(String username, String password, String nickname, {String? invitedBy}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickname': nickname,
        'invitedBy': invitedBy,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception('Registration failed');
    }
  }
  
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception('Login failed');
    }
  }
  
  static Future<Map<String, dynamic>> getUserInfo() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load user info');
    }
  }
  
  static Future<Map<String, dynamic>> createLog(String text) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create log');
    }
  }
  
  static Future<Map<String, dynamic>> createQuickLog(String text) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/logs/quick'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to create quick log');
    }
  }
  
  static Future<List<dynamic>> getHistory() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/logs/history'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load history');
    }
  }
  
  static Future<void> updateLog(int id, String text) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/logs/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to update log');
    }
  }
  
  static Future<void> deleteLog(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/logs/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete log');
    }
  }
  
  static Future<Map<String, dynamic>> getMonthlyStats() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/stats/monthly'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load monthly stats');
    }
  }
  
  static Future<List<dynamic>> getAdminUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load users');
    }
  }
  
  static Future<List<dynamic>> getAdminLogs() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/admin/logs'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load logs');
    }
  }
  
  static Future<void> deleteUser(String username) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/users/$username'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
  
  static Future<void> deleteAnyLog(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/logs/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete log');
    }
  }
}
