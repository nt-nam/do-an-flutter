class NotificationModel {
  final int maTB;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final String noiDung;
  final DateTime ngayGui;
  final String trangThai; // ENUM: 'Chưa đọc', 'Đã đọc'

  NotificationModel({
    required this.maTB,
    this.maTK,
    required this.noiDung,
    required this.ngayGui,
    required this.trangThai,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      maTB: json['MaTB'] as int,
      maTK: json['MaTK'] as int?,
      noiDung: json['NoiDung'] as String,
      ngayGui: DateTime.parse(json['NgayGui'] as String),
      trangThai: json['TrangThai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaTB': maTB,
      'MaTK': maTK,
      'NoiDung': noiDung,
      'NgayGui': ngayGui.toIso8601String(),
      'TrangThai': trangThai,
    };
  }
}