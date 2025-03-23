enum LogType {
  login,
  orderChange,
  systemError,
}
class Log {
  final int id;
  final int? accountId; // Có thể null nếu tài khoản bị xóa
  final String description;
  final DateTime timestamp;
  final LogType type; // 'Đăng nhập', 'Thay đổi đơn hàng', 'Lỗi hệ thống'

  Log({
    required this.id,
    this.accountId,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}