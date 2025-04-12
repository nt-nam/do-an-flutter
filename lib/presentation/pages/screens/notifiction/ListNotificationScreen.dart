import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../../widgets/NotificationCard.dart';
import 'DetailNotificationScreen.dart';

class ListNotificationScreen extends StatefulWidget {
  const ListNotificationScreen({super.key});

  @override
  State<ListNotificationScreen> createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen initializes
    context.read<NotificationBloc>().add(FetchSystemNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (state is SystemNotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyNotificationsView();
            }

            return RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  final shouldExpand = notification.priority >= 4 ||
                      notification.message.length < 100;

                  return NotificationCard(
                    notification: notification,
                    isExpanded: shouldExpand,
                    onTap: () {
                      if (!shouldExpand || notification.imageUrl != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailNotificationScreen(
                              notification: notification,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        },
      ),
    );
  }

  Widget _buildEmptyNotificationsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có thông báo nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tất cả thông báo sẽ hiển thị tại đây',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    context.read<NotificationBloc>().add(FetchSystemNotificationsEvent());
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Lọc thông báo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Các tùy chọn lọc có thể thêm ở đây
              ListTile(
                leading: const Icon(Icons.filter_alt),
                title: const Text('Chỉ xem thông báo chưa đọc'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Implement filter logic
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text('Ưu tiên cao'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // Implement filter logic
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Áp dụng'),
              ),
            ],
          ),
        );
      },
    );
  }
}