// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng nhập')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) return CircularProgressIndicator();
                return ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginEvent(
                      _emailController.text,
                      _passwordController.text,
                    ));
                  },
                  child: Text('Đăng nhập'),
                );
              },
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text('Chưa có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}