import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/notification/create_notifications_usecase.dart';
import '../../../domain/usecases/notification/get_system_notifications_usecase.dart';
import '../../../domain/usecases/notification/update_notification_usecase.dart';
import '../../../domain/usecases/notification/delete_notification_usecase.dart';
import '../../../domain/usecases/notification/mark_notification_as_read_usecase.dart';
import '../../../domain/usecases/notification/get_active_notifications_count_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetSystemNotificationsUseCase getSystemNotificationsUseCase;
  final CreateNotificationUseCase createNotificationUseCase;
  final UpdateNotificationUseCase updateNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final GetActiveNotificationsCountUseCase getActiveNotificationsCountUseCase;

  NotificationBloc({
    required this.getSystemNotificationsUseCase,
    required this.createNotificationUseCase,
    required this.updateNotificationUseCase,
    required this.deleteNotificationUseCase,
    required this.markNotificationAsReadUseCase,
    required this.getActiveNotificationsCountUseCase,
  }) : super(const NotificationInitial()) {
    on<FetchSystemNotificationsEvent>(_onFetchSystemNotifications);
    on<CreateNotificationEvent>(_onCreateNotification);
    on<UpdateNotificationEvent>(_onUpdateNotification);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
  }

  Future<void> _onFetchSystemNotifications(
      FetchSystemNotificationsEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());
    try {
      final notifications = await getSystemNotificationsUseCase(
        type: event.type,
        activeOnly: event.activeOnly,
        limit: event.limit,
        onlyUnread: event.onlyUnread,
      );

      final activeCount = await getActiveNotificationsCountUseCase();
      emit(SystemNotificationsLoaded(notifications, activeCount));
    } catch (e) {
      emit(NotificationError('Failed to fetch notifications: ${e.toString()}'));
    }
  }

  Future<void> _onCreateNotification(
      CreateNotificationEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());
    try {
      await createNotificationUseCase(event.notification);
      emit(const NotificationOperationSuccess('Notification created successfully'));
      add(FetchSystemNotificationsEvent());
    } catch (e) {
      emit(NotificationError('Failed to create notification: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNotification(
      UpdateNotificationEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());
    try {
      await updateNotificationUseCase(event.notification);
      emit(const NotificationOperationSuccess('Notification updated successfully'));
      add(FetchSystemNotificationsEvent());
    } catch (e) {
      emit(NotificationError('Failed to update notification: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNotification(
      DeleteNotificationEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());
    try {
      await deleteNotificationUseCase(event.notificationId);
      emit(const NotificationOperationSuccess('Notification deleted successfully'));
      add(FetchSystemNotificationsEvent());
    } catch (e) {
      emit(NotificationError('Failed to delete notification: ${e.toString()}'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
      MarkNotificationAsReadEvent event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());
    try {
      await markNotificationAsReadUseCase(event.notificationId);
      emit(NotificationMarkedAsRead(event.notificationId));
      add(FetchSystemNotificationsEvent());
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: ${e.toString()}'));
    }
  }
}