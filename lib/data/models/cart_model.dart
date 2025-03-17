class CartModel {
  final int maGH;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final int? maSP; // Có thể null nếu sản phẩm bị xóa
  final int soLuong;
  final DateTime ngayThem;

  CartModel({
    required this.maGH,
    this.maTK,
    this.maSP,
    required this.soLuong,
    required this.ngayThem,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      maGH: json['MaGH'] as int,
      maTK: json['MaTK'] as int?,
      maSP: json['MaSP'] as int?,
      soLuong: json['SoLuong'] as int,
      ngayThem: DateTime.parse(json['NgayThem'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': maGH,
      'MaTK': maTK,
      'MaSP': maSP,
      'SoLuong': soLuong,
      'NgayThem': ngayThem.toIso8601String(),
    };
  }
}