import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost/gas_api/';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String _tokenKey = 'auth_token';

  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await _saveToken(data['token']); // Luôn lưu token
          await saveCurrentAccountId(data['user']['id']); // Lưu MaTK
          return data;
        } else {
          throw Exception('Login failed: ${data['message']}');
        }
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await _saveToken(data['token']); // Luôn lưu token
          await saveCurrentAccountId(data['user']['id']); // Lưu MaTK
          return data;
        } else {
          throw Exception('Registration failed: ${data['message']}');
        }
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  // Lấy token từ bộ nhớ cục bộ
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Lưu token vào bộ nhớ cục bộ
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Xóa token (đăng xuất)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
  // Trong auth_service.dart
  Future<int> getCurrentAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_account_id') ?? 0;
  }

  Future<void> saveCurrentAccountId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_account_id', id);
  }
}