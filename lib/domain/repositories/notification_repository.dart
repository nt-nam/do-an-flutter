import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getSystemNotifications({
    String? type,
    bool activeOnly = true,
    int? limit,
    int? priority,
  });
  Future<void> markAsRead(int notificationId);
  Future<void> updateNotification(NotificationModel notification);
  Future<void> createNotification(NotificationModel notification);
  Future<void> deleteNotification(int notificationId);
}