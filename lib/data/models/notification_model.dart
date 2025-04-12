import '../../domain/entities/notification.dart';

class NotificationModel {
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

  NotificationModel({
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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['MaTB'] as int,
      title: json['TieuDe'] as String,
      message: json['NoiDung'] as String,
      date: DateTime.parse(json['NgayGui'] as String),
      type: NotificationType.values.firstWhere(
            (e) => e.toString().split('.').last == json['LoaiTB'],
        orElse: () => NotificationType.HE_THONG,
      ),
      imageUrl: json['AnhDaiDien'] as String?,
      priority: json['DoUuTien'] as int? ?? 1,
      creator: json['NguoiTao'] as String?,
      displayUntil: json['HienThiDenNgay'] != null
          ? DateTime.parse(json['HienThiDenNgay'] as String)
          : null,
      isActive: json['TrangThai'] == 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaTB': id,
      'TieuDe': title,
      'NoiDung': message,
      'LoaiTB': type.toString().split('.').last,
      'AnhDaiDien': imageUrl,
      'DoUuTien': priority,
      'NguoiTao': creator,
      'HienThiDenNgay': displayUntil?.toIso8601String(),
      'TrangThai': isActive ? 'ACTIVE' : 'INACTIVE',
    };
  }
}