class LogModel {
  final int maNK;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final String moTa;
  final DateTime thoiGian;
  final String loai; // ENUM: 'Đăng nhập', 'Thay đổi đơn hàng', 'Lỗi hệ thống'

  LogModel({
    required this.maNK,
    this.maTK,
    required this.moTa,
    required this.thoiGian,
    required this.loai,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      maNK: json['MaNK'] as int,
      maTK: json['MaTK'] as int?,
      moTa: json['MoTa'] as String,
      thoiGian: DateTime.parse(json['ThoiGian'] as String),
      loai: json['Loai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaNK': maNK,
      'MaTK': maTK,
      'MoTa': moTa,
      'ThoiGian': thoiGian.toIso8601String(),
      'Loai': loai,
    };
  }
}