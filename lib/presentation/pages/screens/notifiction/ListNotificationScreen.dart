import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          'Thông báo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: 'Lọc thông báo',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          } else if (state is SystemNotificationsLoaded) {
            // Get special notifications (priority >= 4)
            final specialNotifications =
                state.notifications.where((n) => n.priority >= 4).toList();

            // Get normal notifications
            final normalNotifications =
                state.notifications.where((n) => n.priority < 4).toList();

            if (state.notifications.isEmpty) {
              return _buildEmptyNotificationsView();
            }

            return RefreshIndicator(
              color: Colors.teal,
              onRefresh: _refreshNotifications,
              child: CustomScrollView(
                slivers: [
                  // Special notifications section
                  if (specialNotifications.isNotEmpty)
                    SliverPadding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông báo quan trọng',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                  if (specialNotifications.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final notification = specialNotifications[index];
                          return NotificationCard(
                            notification: notification,
                            isExpanded: true,
                            // Always expand important notifications
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailNotificationScreen(
                                    notification: notification,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        childCount: specialNotifications.length,
                      ),
                    ),

                  // Normal notifications section
                  SliverPadding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tất cả thông báo',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notification = normalNotifications[index];
                        return NotificationCard(
                          notification: notification,
                          isExpanded: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailNotificationScreen(
                                  notification: notification,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: normalNotifications.length,
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.teal),
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
          Text(
            'Không có thông báo nào',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tất cả thông báo sẽ hiển thị tại đây',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _refreshNotifications,
            child: Text(
              'Làm mới',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lọc thông báo',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.filter_alt, color: Colors.teal),
                title: Text('Chỉ xem thông báo chưa đọc',
                    style: GoogleFonts.poppins()),
                trailing: Switch(
                  activeColor: Colors.teal,
                  value: false,
                  onChanged: (value) {
                    // Implement filter logic
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.priority_high, color: Colors.teal),
                title: Text('Ưu tiên cao', style: GoogleFonts.poppins()),
                trailing: Switch(
                  activeColor: Colors.teal,
                  value: false,
                  onChanged: (value) {
                    // Implement filter logic
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Áp dụng',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
