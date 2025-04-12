import '../../../data/models/notification_model.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class GetSystemNotificationsUseCase {
  final NotificationRepository repository;

  GetSystemNotificationsUseCase(this.repository);

  Future<List<NotificationE>> call({
    NotificationType? type,
    bool activeOnly = true,
    int? limit,
    bool onlyUnread = false,
  }) async {
    try {
      final notificationModels = await repository.getSystemNotifications(
        type: type?.toString().split('.').last,
        activeOnly: activeOnly,
        limit: limit,
      );

      // Lọc thông báo chưa đọc nếu cần
      var filteredNotifications = notificationModels;
      if (onlyUnread) {
        filteredNotifications = notificationModels
            .where((model) => model.isActive) // Hoặc logic khác tùy yêu cầu
            .toList();
      }

      return filteredNotifications.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get system notifications: $e');
    }
  }

  NotificationE _mapToEntity(NotificationModel model) {
    return NotificationE(
      id: model.id,
      title: model.title,
      message: model.message,
      date: model.date,
      type: model.type,
      imageUrl: model.imageUrl,
      priority: model.priority,
      creator: model.creator,
      displayUntil: model.displayUntil,
      isActive: model.isActive,
    );
  }
}