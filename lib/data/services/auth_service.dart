import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.160.1/gas_api/';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String _tokenKey = 'auth_token'; // Key để lưu token trong SharedPreferences

  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  // Đăng nhập và trả về toàn bộ phản hồi từ API
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email, // API mong đợi 'email', không phải 'Email'
          'password': password, // API mong đợi 'password', không phải 'MatKhau'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // API không trả về token, nhưng nếu có token trong tương lai, bạn có thể lưu nó ở đây
          if (data['token'] != null) {
            await _saveToken(data['token']);
          }
          return data; // Trả về toàn bộ dữ liệu từ API
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

  // Đăng ký và trả về toàn bộ phản hồi từ API
  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email, // API mong đợi 'email'
          'password': password, // API mong đợi 'password'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Nếu API trả về token (trong trường hợp đăng ký tự động đăng nhập), lưu token
          if (data['token'] != null) {
            await _saveToken(data['token']);
          }
          return data; // Trả về toàn bộ dữ liệu từ API
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
}