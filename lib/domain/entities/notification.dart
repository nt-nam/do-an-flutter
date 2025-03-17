class Notification {
  final int id;
  final int? accountId; // Có thể null nếu tài khoản bị xóa
  final String content;
  final DateTime sentDate;
  final String status; // 'Chưa đọc', 'Đã đọc'

  Notification({
    required this.id,
    this.accountId,
    required this.content,
    required this.sentDate,
    required this.status,
  });
}