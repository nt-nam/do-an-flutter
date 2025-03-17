class ReviewModel {
  final int maDG;
  final int? maTK; // Có thể null nếu tài khoản bị xóa
  final int? maSP; // Có thể null nếu sản phẩm bị xóa
  final double diem; // CHECK: BETWEEN 1 AND 5
  final String? nhanXet; // Có thể null
  final DateTime ngayDanhGia;

  ReviewModel({
    required this.maDG,
    this.maTK,
    this.maSP,
    required this.diem,
    this.nhanXet,
    required this.ngayDanhGia,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      maDG: json['MaDG'] as int,
      maTK: json['MaTK'] as int?,
      maSP: json['MaSP'] as int?,
      diem: (json['Diem'] as num).toDouble(),
      nhanXet: json['NhanXet'] as String?,
      ngayDanhGia: DateTime.parse(json['NgayDanhGia'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaDG': maDG,
      'MaTK': maTK,
      'MaSP': maSP,
      'Diem': diem,
      'NhanXet': nhanXet,
      'NgayDanhGia': ngayDanhGia.toIso8601String(),
    };
  }
}