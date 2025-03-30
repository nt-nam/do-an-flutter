import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_event.dart';
import '../../../blocs/account/account_state.dart';
import '../HomeScreen.dart';
import 'RegisterScreen.dart'; // Import RegisterScreen

class LoginScreen extends StatefulWidget { // Chuyển sang StatefulWidget
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true; // Biến trạng thái để kiểm soát hiển thị mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền với hình ảnh minh họa
          Image.asset(
            'assets/images/gasdandung/Gemini_Generated_Image_rzmbjerzmbjerzmb.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Nội dung chính
          SafeArea(
            child: BlocListener<AccountBloc, AccountState>(
              listener: (context, state) {
                if (state is AccountLoggedIn) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đăng nhập thành công với ${state.account.email}')),
                  );
                  // Điều hướng sang HomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
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
                      'Cung cấp giải pháp gas an toàn cho ngôi nhà của bạn',
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
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Đổi trạng thái hiển thị mật khẩu
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText, // Sử dụng biến trạng thái
                    ),
                    const SizedBox(height: 24.0),
                    // Nút Đăng nhập
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AccountBloc>().add(
                            LoginEvent(
                              // emailController.text,
                              // passwordController.text,
                              "1@x.x",
                              "1",
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A3C34), // Màu nút giống trong hình
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Nút Tạo tài khoản mới
                    TextButton(
                      onPressed: () {
                        // Chuyển đến RegisterScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Tạo tài khoản mới',
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