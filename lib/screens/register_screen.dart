// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu *',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Họ tên',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
                      );
                    } else {
                      context.read<AuthBloc>().add(RegisterEvent(
                        _emailController.text,
                        _passwordController.text,
                        fullName: _fullNameController.text.isNotEmpty ? _fullNameController.text : null,
                        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                        address: _addressController.text.isNotEmpty ? _addressController.text : null,
                      ));
                    }
                  },
                  child: Text('Đăng ký'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  child: Text('Đã có tài khoản? Đăng nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}