class CartModel {
  final int maGH;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final DateTime ngayThem;
  final String trangThai; // 'Đang hoạt động', 'Đã thanh toán'

  CartModel({
    required this.maGH,
    this.maTK,
    required this.ngayThem,
    required this.trangThai,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      maGH: json['MaGH'] as int,
      maTK: json['MaTK'] as int?,
      ngayThem: DateTime.parse(json['NgayThem'] as String),
      trangThai: json['TrangThai'] as String? ?? 'Đang hoạt động',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': maGH,
      'MaTK': maTK,
      'NgayThem': ngayThem.toIso8601String(),
      'TrangThai': trangThai,
    };
  }
}