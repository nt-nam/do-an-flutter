import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_event.dart';
import '../../../blocs/account/account_state.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registered successfully as ${state.account.email}')),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp không
                  if (passwordController.text != confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
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
                child: const Text('Register'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Quay lại màn hình đăng nhập
                  Navigator.pop(context);
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}