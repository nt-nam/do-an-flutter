abstract class NotificationEvent {
  const NotificationEvent();
}

class FetchNotificationsEvent extends NotificationEvent {
  final int accountId;
  final int page;
  final int limit;

  const FetchNotificationsEvent(this.accountId, {this.page = 1, this.limit = 10});
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final int notificationId;

  const MarkNotificationAsReadEvent(this.notificationId);
}