import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_event.dart';
import '../../../blocs/account/account_state.dart';

class RegisterScreen extends StatefulWidget { // Chuyển sang StatefulWidget
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true; // Trạng thái hiển thị mật khẩu
  bool _obscureConfirmPassword = true; // Trạng thái hiển thị xác nhận mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền với hình ảnh minh họa
          Image.asset(
            'assets/images/gasdandung/GDD_Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg',
            fit: BoxFit.cover, // Đảm bảo ảnh nền phủ toàn bộ màn hình
            width: double.infinity,
            height: double.infinity,
          ),
          // Nội dung chính
          SafeArea(
            child: BlocListener<AccountBloc, AccountState>(
              listener: (context, state) {
                if (state is AccountRegistered) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đăng ký thành công với ${state.account.email}')),
                  );
                  // Chuyển về màn hình đăng nhập sau khi đăng ký thành công
                  Navigator.pop(context);
                } else if (state is AccountError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Đặt nội dung ở dưới cùng
                  children: [
                    // Khẩu hiệu
                    const Text(
                      'Tạo tài khoản để trải nghiệm giải pháp gas an toàn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    // Trường nhập email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Trường nhập mật khẩu
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword; // Đổi trạng thái
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword, // Sử dụng biến trạng thái
                    ),
                    const SizedBox(height: 16.0),
                    // Trường xác nhận mật khẩu
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword; // Đổi trạng thái
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword, // Sử dụng biến trạng thái
                    ),
                    const SizedBox(height: 24.0),
                    // Nút Đăng ký
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
                          if (passwordController.text != confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mật khẩu không khớp')),
                            );
                            return;
                          }
                          context.read<AccountBloc>().add(
                            RegisterEvent(
                              emailController.text,
                              passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3C34), // Màu nút giống LoginScreen
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Nút Quay lại đăng nhập
                    TextButton(
                      onPressed: () {
                        // Quay lại màn hình đăng nhập
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Đã có tài khoản? Đăng nhập',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}