enum OrderStatus {
  pending,
  delivering,
  delivered,
  cancelled,
}

class OrderModel {
  final int maDH;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final int? maGH; // Thêm để liên kết với Cart
  final DateTime ngayDat;
  final double tongTien;
  final OrderStatus trangThai;
  final String diaChiGiao;
  final int? maUD; // Có thể null nếu không có ưu đãi

  OrderModel({
    required this.maDH,
    this.maTK,
    this.maGH,
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
      maGH: json['MaGH'] as int?,
      ngayDat: DateTime.parse(json['NgayDat'] as String),
      tongTien: (json['TongTien'] as num).toDouble(),
      trangThai: OrderStatus.values.firstWhere(
            (e) => e.name == json['TrangThai'],
        orElse: () => OrderStatus.pending,
      ),
      diaChiGiao: json['DiaChiGiao'] as String,
      maUD: json['MaUD'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaDH': maDH,
      'MaTK': maTK,
      'MaGH': maGH,
      'NgayDat': ngayDat.toIso8601String(),
      'TongTien': tongTien,
      'TrangThai': trangThai.name,
      'DiaChiGiao': diaChiGiao,
      'MaUD': maUD,
    };
  }
}