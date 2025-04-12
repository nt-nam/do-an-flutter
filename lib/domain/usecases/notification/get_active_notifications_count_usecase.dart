import '../../repositories/notification_repository.dart';

class GetActiveNotificationsCountUseCase {
  final NotificationRepository repository;

  GetActiveNotificationsCountUseCase(this.repository);

  Future<int> call() async {
    try {
      final notifications = await repository.getSystemNotifications(
        activeOnly: true,
      );
      return notifications.length;
    } catch (e) {
      throw Exception('Failed to get active notifications count: $e');
    }
  }
}