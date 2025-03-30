enum OrderStatus {
  pending,
  delivering,
  delivered,
  cancelled,
}


class OrderModel {
  final int? maDH;
  final int? maTK;
  final int? maGH;
  final DateTime ngayDat;
  final double tongTien;
  final OrderStatus trangThai;
  final String? diaChiGiao;
  final int? maUD;

  OrderModel({
    required this.maDH,
    required this.maTK,
    this.maGH,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,
    this.diaChiGiao,
    this.maUD,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Xử lý TrangThai an toàn
    final statusString = json['TrangThai']?.toString().toLowerCase();
    OrderStatus status;
    try {
      status = OrderStatus.values.firstWhere(
            (e) => e.toString() == 'OrderStatus.$statusString',
        orElse: () => OrderStatus.pending,
      );
    } catch (e) {
      status = OrderStatus.pending; // Giá trị mặc định nếu có lỗi
    }

    return OrderModel(
      maDH: json['MaDH'] as int?,
      maTK: json['MaTK'] as int?,
      maGH: json['MaGH'] as int?,
      ngayDat: DateTime.parse(json['NgayDat'] as String? ?? DateTime.now().toString()),
      tongTien: (json['TongTien'] as num?)?.toDouble() ?? 0.0,
      trangThai: status,
      diaChiGiao: json['DiaChiGiao'] as String?,
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
      'TrangThai': trangThai.toString().split('.').last,
      'DiaChiGiao': diaChiGiao,
      'MaUD': maUD,
    };
  }
}

