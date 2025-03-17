class OrderModel {
  final int maDH;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final DateTime ngayDat;
  final double tongTien;
  final String trangThai; // ENUM: 'Chờ xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'
  final String diaChiGiao;
  final int? maUD; // Có thể null nếu không có ưu đãi

  OrderModel({
    required this.maDH,
    this.maTK,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,
    required this.diaChiGiao,
    this.maUD,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      maDH: json['MaDH'] as int,
      maTK: json['MaTK'] as int?,
      ngayDat: DateTime.parse(json['NgayDat'] as String),
      tongTien: (json['TongTien'] as num).toDouble(),
      trangThai: json['TrangThai'] as String,
      diaChiGiao: json['DiaChiGiao'] as String,
      maUD: json['MaUD'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaDH': maDH,
      'MaTK': maTK,
      'NgayDat': ngayDat.toIso8601String(),
      'TongTien': tongTien,
      'TrangThai': trangThai,
      'DiaChiGiao': diaChiGiao,
      'MaUD': maUD,
    };
  }
}