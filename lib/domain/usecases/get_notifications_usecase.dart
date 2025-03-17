import '../entities/notification.dart';
import '../repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<Notification>> call(int? accountId, {bool onlyUnread = false, int page = 1, int limit = 10}) async {
    try {
      if (accountId == null) {
        // Trường hợp null: trả về danh sách trống hoặc logic khác tùy yêu cầu
        return [];
      }
      final notificationModels = await repository.getNotifications(accountId);
      var filteredNotifications = notificationModels;
      if (onlyUnread) {
        filteredNotifications = notificationModels.where((model) => model.trangThai == 'Chưa đọc').toList();
      }
      return filteredNotifications.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  Notification _mapToEntity(NotificationModel model) {
    return Notification(
      id: model.maTB,
      accountId: model.maTK,
      content: model.noiDung,
      sentDate: model.ngayGui,
      status: model.trangThai,
    );
  }
}