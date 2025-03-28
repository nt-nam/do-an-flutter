import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_event.dart';
import '../../../blocs/account/account_state.dart';
import '../HomeScreen.dart';
import 'RegisterScreen.dart'; // Import RegisterScreen

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logged in as ${state.account.email}')),
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
              const SizedBox(height: 16.0), // Thêm khoảng cách
              ElevatedButton(
                onPressed: () {
                  context.read<AccountBloc>().add(
                    LoginEvent(
                      // emailController.text,
                      // passwordController.text,
                      "test1@mail.xx",
                      "123"
                    ),
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16.0), // Thêm khoảng cách
              TextButton(
                onPressed: () {
                  // Chuyển đến RegisterScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}