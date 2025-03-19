class ReviewModel {
  final int maDG;
  final int? maTK;
  final int? maSP;
  final double diem;
  final String? nhanXet;
  final DateTime ngayDanhGia;
  final int? maDH;

  ReviewModel({
    required this.maDG,
    this.maTK,
    this.maSP,
    required this.diem,
    this.nhanXet,
    required this.ngayDanhGia,
    required this.maDH,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      maDG: json['MaDG'] as int,
      maTK: json['MaTK'] as int?,
      maSP: json['MaSP'] as int?,
      diem: (json['Diem'] as num).toDouble(),
      nhanXet: json['NhanXet'] as String?,
      ngayDanhGia: DateTime.parse(json['NgayDanhGia'] as String),
      maDH: json['MaDH'] as int?, // Sửa từ MaHD thành MaDH
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
      'MaDH': maDH,
    };
  }
}