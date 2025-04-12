enum NotificationType {
  HE_THONG,      // Thông báo hệ thống
  UU_DAI,        // Ưu đãi, khuyến mãi
  BAO_MAT,       // Cảnh báo bảo mật
  SU_KIEN,       // Sự kiện
  CA_NHAN,       // Thông tin cá nhân
  THONG_BAO_KHAC // Loại khác
}

class NotificationE {
  final int id;
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;
  final String? imageUrl;
  final int priority;
  final String? creator;
  final DateTime? displayUntil;
  final bool isActive;

  NotificationE({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
    this.imageUrl,
    this.priority = 1,
    this.creator,
    this.displayUntil,
    this.isActive = true,
  });
}