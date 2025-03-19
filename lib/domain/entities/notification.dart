enum NotificationStatus {
  unread,
  read,
}
class Notification {
  final int id;
  final int? accountId;
  final int? orderId;
  final int? offerId;
  final String content;
  final DateTime sentDate;
  final NotificationStatus status;// 'Chưa đọc', 'Đã đọc'

  Notification({
    required this.id,
    this.accountId,
    this.orderId,
    this.offerId,
    required this.content,
    required this.sentDate,
    required this.status,
  });
}
