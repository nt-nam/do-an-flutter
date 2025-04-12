import '../../domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationE>> getNotifications();
}

class NotificationRepositoryImpl implements NotificationRepository {
  @override
  Future<List<NotificationE>> getNotifications() async {
    // Giả lập dữ liệu hoặc gọi API thực tế
    await Future.delayed(const Duration(seconds: 1));
    return [
      NotificationE(
        id: 1,
        title: 'Đơn hàng đã giao',
        message: 'Đơn hàng #123 đã được giao thành công.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.THONG_BAO_KHAC,
      ),
      NotificationE(
        id: 2,
        title: 'Cảnh báo thanh toán',
        message: 'Vui lòng thanh toán đơn hàng #124 trước ngày 15/04.',
        date: DateTime.now(),
        type: NotificationType.THONG_BAO_KHAC,
      ),
    ];
  }
}