import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(int accountId);
  Future<void> markAsRead(int notificationId);
  Future<void> updateNotification(NotificationModel notification);
}