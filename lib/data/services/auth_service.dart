import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/account.dart'; // Thêm import

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
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (data['token'] != null) {
            await _saveToken(data['token']);
          }
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
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (data['token'] != null) {
            await _saveToken(data['token']);
          }
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

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Giả lập validateToken (tạm thời không gọi API)
  Future<Account> validateToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_tokenKey);
    if (storedToken == token && token.isNotEmpty) {
      // Giả định tài khoản hợp lệ nếu token tồn tại
      // Trong thực tế, cần gọi API để xác thực
      return Account(
        id: 0, // Giá trị mặc định, cần thay bằng dữ liệu thực tế từ API
        email: '',
        password: '',
        role: 'Khách hàng',
        isActive: true,
      );
    } else {
      throw Exception('Invalid token');
    }
  }
}