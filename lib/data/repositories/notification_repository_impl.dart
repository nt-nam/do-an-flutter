import '../models/notification_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiService apiService;
  final AuthService authService;

  NotificationRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<NotificationModel>> getSystemNotifications({
    String? type,
    bool activeOnly = true,
    int? limit,
  }) async {
    final token = await authService.getToken();
    final queryParams = {
      if (type != null) 'loaiTB': type,
      'trangThai': activeOnly ? 'ACTIVE' : 'ALL',
      if (limit != null) 'limit': limit.toString(),
    };

    final endpoint = 'thongbao?${Uri(queryParameters: queryParams).query}';
    final data = await apiService.get(endpoint, token: token);

    return (data as List).map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    final token = await authService.getToken();
    await apiService.put(
      'thongbao/$notificationId',
      {'TrangThai': 'Đã đọc'},
      token: token,
    );
  }

  @override
  Future<void> updateNotification(NotificationModel notification) async {
    final token = await authService.getToken();
    await apiService.put(
      'thongbao/${notification.id}',
      notification.toJson(),
      token: token,
    );
  }

  @override
  Future<void> createNotification(NotificationModel notification) async {
    final token = await authService.getToken();
    await apiService.post(
      'thongbao',
      notification.toJson(),
      token: token,
    );
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    final token = await authService.getToken();
    await apiService.delete(
      'thongbao/$notificationId',
      token: token,
    );
  }
}