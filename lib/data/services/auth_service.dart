import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Để lưu token cục bộ

class AuthService {
  static const String baseUrl = 'http://your-php-api-domain.com/api'; // Thay bằng URL thực tế
  static const String loginEndpoint = '/login'; // Endpoint đăng nhập
  static const String _tokenKey = 'auth_token'; // Key để lưu token trong SharedPreferences

  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  // Đăng nhập và lấy token
  Future<String> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Email': email,
          'MatKhau': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String; // Giả định API trả về trường 'token'
        await _saveToken(token); // Lưu token
        return token;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
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
}