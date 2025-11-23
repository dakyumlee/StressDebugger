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

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> register(String username, String password, String nickname, [String? inviteCode]) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'nickname': nickname,
        if (inviteCode != null) 'inviteCode': inviteCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(utf8.decode(response.bodyBytes));
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
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }

  static Future<Map<String, dynamic>> createLog(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logs'),
      headers: await getHeaders(),
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('로그 생성 실패: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> createQuickLog(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logs/quick'),
      headers: await getHeaders(),
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('퀵로그 생성 실패');
    }
  }

  static Future<List<dynamic>> getHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/logs/history'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('히스토리 불러오기 실패');
    }
  }

  static Future<void> updateLog(int id, String text) async {
    final response = await http.put(
      Uri.parse('$baseUrl/logs/$id'),
      headers: await getHeaders(),
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode != 200) {
      throw Exception('로그 수정 실패');
    }
  }

  static Future<void> deleteLog(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/logs/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('로그 삭제 실패');
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/info'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('유저 정보 불러오기 실패');
    }
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/profile'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('프로필 불러오기 실패');
    }
  }

  static Future<void> updateUserProfile({
    String? humorPreference,
    int? sensitivityLevel,
    String? preferredMessageLength,
    String? preferredNickname,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/profile'),
      headers: await getHeaders(),
      body: jsonEncode({
        if (humorPreference != null) 'humorPreference': humorPreference,
        if (sensitivityLevel != null) 'sensitivityLevel': sensitivityLevel,
        if (preferredMessageLength != null) 'preferredMessageLength': preferredMessageLength,
        if (preferredNickname != null) 'preferredNickname': preferredNickname,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('프로필 업데이트 실패');
    }
  }

  static Future<Map<String, dynamic>> chatWithAI(String message, List<Map<String, String>> history) async {
    final profile = await getUserProfile();
    
    final response = await http.post(
      Uri.parse('https://stressdebuggerai-production.up.railway.app/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'userProfile': profile,
        'history': history,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('AI 채팅 실패');
    }
  }

  static Future<Map<String, dynamic>> getMonthlyStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/stats/monthly'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('월간 통계 불러오기 실패');
    }
  }

  static Future<List<dynamic>> getAdminUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/users'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('유저 목록 불러오기 실패');
    }
  }

  static Future<List<dynamic>> getAdminLogs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/logs'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('로그 목록 불러오기 실패');
    }
  }

  static Future<void> deleteUser(String username) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/users/$username'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('유저 삭제 실패');
    }
  }

  static Future<void> deleteAnyLog(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/logs/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('로그 삭제 실패');
    }
  }
}
