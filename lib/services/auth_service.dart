// lib/services/auth_service.dart
import '../models/user_model.dart';
import 'package:http/http.dart' as http; // Import thư viện http
import 'dart:convert'; // Import để sử dụng jsonEncode và jsonDecode
class AuthService {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/gas_api/auth/login.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Decoded data: $data');

        if (data['status'] == 'success') {
          // Kiểm tra xem dữ liệu người dùng có nằm trong một trường con không
          final userData = data['user'] ?? data['data'] ?? data;
          print('User data: $userData');
          return UserModel.fromJson(userData);
        } else {
          throw Exception(data['message'] ?? 'Đăng nhập thất bại');
        }
      } else {
        throw Exception('Đăng nhập thất bại: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow; // Ném lại lỗi để xử lý ở UI
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String address,
  }) async {
    // Mock data thay vì gọi API
    await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
    return UserModel(
      id: 2,
      email: email,
      role: 'customer',
      isActive: true,
      fullName: fullName,
      phone: phone,
      address: address,
    );

    // Khi dùng API thật (PHP/phpMyAdmin):
    // final response = await http.post(
    //   Uri.parse('http://your-php-server/auth/register.php'),
    //   body: {
    //     'email': email,
    //     'password': password,
    //     'fullName': fullName,
    //     'phone': phone,
    //     'address': address,
    //   },
    // );
    // if (response.statusCode == 201) {
    //   return UserModel.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Đăng ký thất bại');
    // }
  }

  Future<void> logout() async {
    // Mock logout (không làm gì)
    await Future.delayed(Duration(seconds: 1));
  }
}