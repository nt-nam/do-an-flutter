import '../../../data/models/notification_model.dart';
import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';

class CreateNotificationUseCase {
  final NotificationRepository repository;

  CreateNotificationUseCase(this.repository);

  Future<void> call(NotificationE notification) async {
    try {
      final model = _mapToModel(notification);
      await repository.createNotification(model);
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  NotificationModel _mapToModel(NotificationE entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      date: entity.date,
      type: entity.type,
      imageUrl: entity.imageUrl,
      priority: entity.priority,
      creator: entity.creator,
      displayUntil: entity.displayUntil,
      isActive: entity.isActive,
    );
  }
}