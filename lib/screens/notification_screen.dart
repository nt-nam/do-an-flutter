// lib/screens/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification_bloc.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(LoadNotificationsEvent());

    return Scaffold(
      appBar: AppBar(title: Text('Thông báo')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(child: Text('Chưa có thông báo nào'));
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return ListTile(
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(notification.message),
                  trailing: Text(
                    notification.createdAt.toString().substring(0, 16),
                    style: TextStyle(color: Colors.grey),
                  ),
                  tileColor: notification.isRead ? null : Colors.grey[200],
                  onTap: () {
                    // Có thể thêm logic đánh dấu đã đọc
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã xem: ${notification.title}')),
                    );
                  },
                );
              },
            );
          }
          if (state is NotificationError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Chưa có dữ liệu thông báo'));
        },
      ),
    );
  }
}