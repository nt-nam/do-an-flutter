// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
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
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LoginEvent(_emailController.text, _passwordController.text));
                },
                child: Text('Đăng nhập'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Chưa có tài khoản? Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}