enum OrderStatus {
  pending,
  delivering,
  delivered,
  cancelled,
}

class OrderModel {
  final int maDH;
  final int? maTK;
  final int? maGH;
  final DateTime ngayDat;
  final double tongTien;
  final OrderStatus trangThai;
  final String diaChiGiao;
  final int? maUD;

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
    // Ánh xạ trạng thái từ tiếng Việt sang OrderStatus
    String trangThaiStr = json['TrangThai'] as String;
    OrderStatus status;
    switch (trangThaiStr) {
      case 'Đã giao':
        status = OrderStatus.delivered;
        break;
      case 'Đang giao':
        status = OrderStatus.delivering;
        break;
      case 'Chờ xác nhận':
        status = OrderStatus.pending;
        break;
      case 'Đã hủy':
        status = OrderStatus.cancelled;
        break;
      default:
        status = OrderStatus.pending; // Giá trị mặc định nếu không khớp
    }

    return OrderModel(
      maDH: json['MaDH'] as int,
      maTK: json['MaTK'] as int?,
      maGH: json['MaGH'] as int?,
      ngayDat: DateTime.parse(json['NgayDat'] as String),
      tongTien: (json['TongTien'] as num).toDouble(),
      trangThai: status,
      diaChiGiao: json['DiaChiGiao'] as String,
      maUD: json['MaUD'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    // Ánh xạ ngược từ OrderStatus sang tiếng Việt khi gửi dữ liệu lên API
    String trangThaiStr;
    switch (trangThai) {
      case OrderStatus.delivered:
        trangThaiStr = 'Đã giao';
        break;
      case OrderStatus.delivering:
        trangThaiStr = 'Đang giao';
        break;
      case OrderStatus.pending:
        trangThaiStr = 'Chờ xác nhận';
        break;
      case OrderStatus.cancelled:
        trangThaiStr = 'Đã hủy';
        break;
    }

    return {
      'MaDH': maDH,
      'MaTK': maTK,
      'MaGH': maGH,
      'NgayDat': ngayDat.toIso8601String(),
      'TongTien': tongTien,
      'TrangThai': trangThaiStr,
      'DiaChiGiao': diaChiGiao,
      'MaUD': maUD,
    };
  }
}