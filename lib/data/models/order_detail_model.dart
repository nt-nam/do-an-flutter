class OrderDetailModel {
  final int? maCTDH; // Cho phép null
  final int? maDH; // Cho phép null
  final int? maSP; // Cho phép null
  final int? soLuong; // Cho phép null
  final double? giaLucMua; // Cho phép null

  OrderDetailModel({
    required this.maCTDH,
    required this.maDH,
    required this.maSP,
    required this.soLuong,
    required this.giaLucMua,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      maCTDH: json['MaCTDH'] as int?, // Cho phép null
      maDH: json['MaDH'] as int?, // Cho phép null
      maSP: json['MaSP'] as int?, // Cho phép null
      soLuong: json['SoLuong'] as int?, // Cho phép null
      giaLucMua: (json['GiaLucMua'] as num?)?.toDouble(), // Cho phép null
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