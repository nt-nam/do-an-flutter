import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is NotificationMarkedAsRead) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked as read')));
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return ListTile(
                  title: Text(notification.content),
                  subtitle: Text('Status: ${notification.status} - ${notification.sentDate}'),
                  trailing: notification.status == 'Chưa đọc'
                      ? ElevatedButton(
                    onPressed: () {
                      context.read<NotificationBloc>().add(MarkNotificationAsReadEvent(notification.id));
                    },
                    child: const Text('Mark as Read'),
                  )
                      : null,
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(const FetchNotificationsEvent(1)); // Giả định accountId = 1
              },
              child: const Text('Load Notifications'),
            ),
          );
        },
      ),
    );
  }
}