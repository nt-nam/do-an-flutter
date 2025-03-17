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

class NotificationLoaded extends NotificationState {
  final List<Notification> notifications;

  const NotificationLoaded(this.notifications);
}

class NotificationMarkedAsRead extends NotificationState {
  final int notificationId;

  const NotificationMarkedAsRead(this.notificationId);
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);
}