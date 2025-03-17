import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';
import '../../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  NotificationBloc(
      this.getNotificationsUseCase,
      this.markNotificationAsReadUseCase,
      ) : super(const NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
  }

  Future<void> _onFetchNotifications(FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoading());
    try {
      final notifications = await getNotificationsUseCase(event.accountId, page: event.page, limit: event.limit);
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onMarkNotificationAsRead(MarkNotificationAsReadEvent event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoading());
    try {
      await markNotificationAsReadUseCase(event.notificationId);
      emit(NotificationMarkedAsRead(event.notificationId));
      // Tải lại danh sách thông báo
      final notifications = await getNotificationsUseCase((state as NotificationLoaded).notifications.first.accountId);
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

}