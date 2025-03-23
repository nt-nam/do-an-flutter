import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;
  final AuthService authService;

  NotificationRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<NotificationModel>> getNotifications(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('thongbao?MaTK=$accountId', token: token);
    return (data as List).map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    final token = await authService.getToken();
    await apiService.put('thongbao/$notificationId', {'TrangThai': 'Đã đọc'}, token: token);
  }

  @override
  Future<void> updateNotification(NotificationModel notification) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }
}