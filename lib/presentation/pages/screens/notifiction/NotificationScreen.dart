import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/notification.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color goldColor = Color(0xFFFFD700);
  static const Color whiteColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    // Tự động gọi sự kiện fetch khi màn hình được tải
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(const FetchNotificationsEvent(1));
    });

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: goldColor,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              goldColor.withOpacity(0.1),
              whiteColor,
            ],
          ),
        ),
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is NotificationMarkedAsRead) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Marked as read'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NotificationLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: goldColor,
                ),
              );
            } else if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return Card(
                    color: whiteColor,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(
                        notification.content,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Status: ${notification.status == NotificationStatus.unread ? "Chưa đọc" : "Đã đọc"} - ${notification.sentDate}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: notification.status == NotificationStatus.unread
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () {
                          context.read<NotificationBloc>().add(
                            MarkNotificationAsReadEvent(notification.id),
                          );
                        },
                        child: const Text('Mark as Read'),
                      )
                          : const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              );
            }
            return _buildInitialState(context);
          },
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 60,
            color: goldColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              context.read<NotificationBloc>().add(const FetchNotificationsEvent(1));
            },
            child: const Text(
              'Load Notifications',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_off,
            size: 60,
            color: goldColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              context.read<NotificationBloc>().add(const FetchNotificationsEvent(1));
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}