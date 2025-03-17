class ProductModel {
  final int maSP;
  final String tenSP;
  final String? moTa; // Có thể null
  final double gia;
  final int? maLoai; // Có thể null
  final String? hinhAnh; // Có thể null
  final String trangThai; // ENUM: 'Còn hàng', 'Hết hàng'

  ProductModel({
    required this.maSP,
    required this.tenSP,
    this.moTa,
    required this.gia,
    this.maLoai,
    this.hinhAnh,
    required this.trangThai,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      maSP: json['MaSP'] as int,
      tenSP: json['TenSP'] as String,
      moTa: json['MoTa'] as String?,
      gia: (json['Gia'] as num).toDouble(),
      maLoai: json['MaLoai'] as int?,
      hinhAnh: json['HinhAnh'] as String?,
      trangThai: json['TrangThai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaSP': maSP,
      'TenSP': tenSP,
      'MoTa': moTa,
      'Gia': gia,
      'MaLoai': maLoai,
      'HinhAnh': hinhAnh,
      'TrangThai': trangThai,
    };
  }
}