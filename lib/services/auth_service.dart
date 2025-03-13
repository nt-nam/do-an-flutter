// lib/services/auth_service.dart
import '../models/user_model.dart';

class AuthService {
  Future<UserModel> login(String email, String password) async {
    // Mock data thay vì gọi API
    await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
    if (email == 'test@example.com' && password == '123456') {
      return UserModel(
        id: 1,
        email: email,
        role: 'customer',
        isActive: true,
        fullName: 'Nguyen Van A',
        phone: '0901234567',
        address: '123 Đường Láng, Hà Nội',
      );
    } else {
      throw Exception('Sai email hoặc mật khẩu');
    }

    // Khi dùng API thật (PHP/phpMyAdmin):
    // final response = await http.post(
    //   Uri.parse('http://your-php-server/auth/login.php'),
    //   body: {'email': email, 'password': password},
    // );
    // if (response.statusCode == 200) {
    //   return UserModel.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('Đăng nhập thất bại');
    // }
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