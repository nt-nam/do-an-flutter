// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Họ tên: ${user.fullName ?? 'Chưa cập nhật'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Vai trò: ${user.role}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Trạng thái: ${user.isActive ? 'Hoạt động' : 'Không hoạt động'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Số điện thoại: ${user.phone ?? 'Chưa cập nhật'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Địa chỉ: ${user.address ?? 'Chưa cập nhật'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: Text('Đăng xuất'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(child: Text('Vui lòng đăng nhập để xem hồ sơ'));
        },
      ),
    );
  }
}