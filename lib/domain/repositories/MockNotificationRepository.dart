import '../../data/models/notification_model.dart';
import 'notification_repository.dart';

class MockNotificationRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getNotifications(int accountId) async {
    // Dữ liệu giả lập
    return [
      NotificationModel(
        maTB: 1,
        maTK: 1,
        noiDung: "Thông báo 1: Chào mừng bạn!",
        ngayGui: DateTime.now().subtract(const Duration(days: 1)),
        trangThai: "Chưa đọc",
      ),
      NotificationModel(
        maTB: 2,
        maTK: 1,
        noiDung: "Thông báo 2: Cập nhật mới!",
        ngayGui: DateTime.now().subtract(const Duration(hours: 2)),
        trangThai: "Đã đọc",
      ),
    ];
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    // Giả lập hành động đánh dấu đã đọc
    await Future.delayed(const Duration(milliseconds: 500)); // Giả lập độ trễ
  }

  @override
  Future<void> updateNotification(NotificationModel notification) async {
    // Không cần triển khai cho test
    throw UnimplementedError();
  }
}