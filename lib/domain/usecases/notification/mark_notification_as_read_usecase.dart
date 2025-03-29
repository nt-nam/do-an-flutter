import '../../entities/notification.dart';
import '../../repositories/notification_repository.dart';
import '../../../data/models/notification_model.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(int notificationId) async {
    try {
      // Giả định cập nhật trạng thái thành "Đã đọc"
      final notificationModel = NotificationModel(
        maTB: notificationId,
        maTK: 0, // Không cần cập nhật, API sẽ giữ nguyên
        noiDung: '', // Không cần cập nhật
        ngayGui: DateTime.now(), // Không cần cập nhật
        trangThai: 'Đã đọc',
      );
      await repository.updateNotification(notificationModel);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }
}