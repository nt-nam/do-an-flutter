class OrderDetailModel {
  final int maCTDH; // Thêm khóa chính
  final int maDH;
  final int maSP;
  final int soLuong;
  final double giaLucMua;

  OrderDetailModel({
    required this.maCTDH,
    required this.maDH,
    required this.maSP,
    required this.soLuong,
    required this.giaLucMua,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      maCTDH: json['MaCTDH'] as int,
      maDH: json['MaDH'] as int,
      maSP: json['MaSP'] as int,
      soLuong: json['SoLuong'] as int,
      giaLucMua: (json['GiaLucMua'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaCTDH': maCTDH,
      'MaDH': maDH,
      'MaSP': maSP,
      'SoLuong': soLuong,
      'GiaLucMua': giaLucMua,
    };
  }
}