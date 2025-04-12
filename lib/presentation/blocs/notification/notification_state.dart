import '../../../domain/entities/notification.dart';

abstract class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class SystemNotificationsLoaded extends NotificationState {
  final List<NotificationE> notifications;
  final int activeCount;

  const SystemNotificationsLoaded(this.notifications, this.activeCount);
}

class NotificationOperationSuccess extends NotificationState {
  final String message;

  const NotificationOperationSuccess(this.message);
}

class NotificationMarkedAsRead extends NotificationState {
  final int notificationId;

  const NotificationMarkedAsRead(this.notificationId);
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);
}