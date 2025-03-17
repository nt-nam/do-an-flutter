class ImportModel {
  final int maNhap;
  final int? maSP; // Có thể null nếu sản phẩm bị xóa
  final int? maKho; // Có thể null nếu kho bị xóa
  final int soLuong;
  final DateTime ngayNhap;

  ImportModel({
    required this.maNhap,
    this.maSP,
    this.maKho,
    required this.soLuong,
    required this.ngayNhap,
  });

  factory ImportModel.fromJson(Map<String, dynamic> json) {
    return ImportModel(
      maNhap: json['MaNhap'] as int,
      maSP: json['MaSP'] as int?,
      maKho: json['MaKho'] as int?,
      soLuong: json['SoLuong'] as int,
      ngayNhap: DateTime.parse(json['NgayNhap'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaNhap': maNhap,
      'MaSP': maSP,
      'MaKho': maKho,
      'SoLuong': soLuong,
      'NgayNhap': ngayNhap.toIso8601String(),
    };
  }
}