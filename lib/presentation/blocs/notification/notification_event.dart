import '../../../domain/entities/notification.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class FetchSystemNotificationsEvent extends NotificationEvent {
  final NotificationType? type;
  final bool activeOnly;
  final int? limit;
  final bool onlyUnread;

  const FetchSystemNotificationsEvent({
    this.type,
    this.activeOnly = true,
    this.limit,
    this.onlyUnread = false,
  });
}

class CreateNotificationEvent extends NotificationEvent {
  final NotificationE notification;

  const CreateNotificationEvent(this.notification);
}

class UpdateNotificationEvent extends NotificationEvent {
  final NotificationE notification;

  const UpdateNotificationEvent(this.notification);
}

class DeleteNotificationEvent extends NotificationEvent {
  final int notificationId;

  const DeleteNotificationEvent(this.notificationId);
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final int notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);
}