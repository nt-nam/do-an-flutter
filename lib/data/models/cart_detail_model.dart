class CartDetailModel {
  final int maGH;
  final int maSP;
  final int soLuong;
  final String? tenSP; // Nullable, không bắt buộc
  final double? gia;   // Nullable, không bắt buộc
  final String? hinhAnh;

  CartDetailModel({
    required this.maGH,
    required this.maSP,
    required this.soLuong,
    this.tenSP, // Không bắt buộc
    this.gia,   // Không bắt buộc
    this.hinhAnh,
  });

  factory CartDetailModel.fromJson(Map<String, dynamic> json) {
    return CartDetailModel(
      maGH: json['MaGH'] as int,
      maSP: json['MaSP'] as int,
      soLuong: json['SoLuong'] as int,
      tenSP: json['TenSP'] as String?,
      gia: (json['Gia'] as num?)?.toDouble(),
      hinhAnh: json['HinhAnh'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': maGH,
      'MaSP': maSP,
      'SoLuong': soLuong,
      if (tenSP != null) 'TenSP': tenSP,
      if (gia != null) 'Gia': gia,
      if (hinhAnh != null) 'HinhAnh': hinhAnh,
    };
  }
}