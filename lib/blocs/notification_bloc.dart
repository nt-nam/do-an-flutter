// lib/blocs/notification_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/notification_model.dart';

abstract class NotificationEvent {}
class LoadNotificationsEvent extends NotificationEvent {}

abstract class NotificationState {}
class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);
}
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  List<NotificationModel> _notifications = []; // Mock danh sách thông báo

  NotificationBloc() : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      // Mock: Tạo dữ liệu giả lập
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      if (_notifications.isEmpty) {
        _notifications = [
          NotificationModel(
            id: 1,
            title: 'Đơn hàng #123 đã giao',
            message: 'Đơn hàng của bạn đã được giao thành công lúc 10:00 hôm nay.',
            createdAt: DateTime.now().subtract(Duration(hours: 2)),
          ),
          NotificationModel(
            id: 2,
            title: 'Khuyến mãi mới',
            message: 'Giảm 20% cho đơn hàng tiếp theo với mã NEW20.',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
          ),
        ];
      }
      emit(NotificationLoaded(_notifications));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/notifications/list.php'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   _notifications = json.map((data) => NotificationModel.fromJson(data)).toList();
      //   emit(NotificationLoaded(_notifications));
      // } else {
      //   throw Exception('Không tải được thông báo');
      // }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}