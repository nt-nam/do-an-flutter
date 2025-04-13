import '../../domain/entities/review.dart';

class ReviewModel {
  final int maDG;
  final int? maTK;
  final int? maSP;
  final int? maDH;
  final int diem; // Thay đổi từ double sang int
  final String? nhanXet;
  final List<String>? hinhAnh; // Thêm trường hình ảnh
  final String? phanHoiTuShop; // Thêm phản hồi từ shop
  final DateTime ngayDanhGia;
  final bool anDanh; // Thêm trường ẩn danh

  ReviewModel({
    required this.maDG,
    this.maTK,
    this.maSP,
    this.maDH,
    required this.diem,
    this.nhanXet,
    this.hinhAnh,
    this.phanHoiTuShop,
    required this.ngayDanhGia,
    required this.anDanh,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      maDG: json['MaDG'] as int,
      maTK: json['MaTK'] as int?,
      maSP: json['MaSP'] as int?,
      maDH: json['MaDH'] as int?,
      diem: json['Diem'] as int,
      nhanXet: json['NhanXet'] as String?,
      hinhAnh: json['HinhAnh'] != null
          ? List<String>.from(json['HinhAnh'] as List)
          : null,
      phanHoiTuShop: json['PhanHoiTuShop'] as String?,
      ngayDanhGia: DateTime.parse(json['NgayDanhGia'] as String),
      anDanh: json['AnDanh'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaDG': maDG,
      'MaTK': maTK,
      'MaSP': maSP,
      'MaDH': maDH,
      'Diem': diem,
      'NhanXet': nhanXet,
      'HinhAnh': hinhAnh,
      'PhanHoiTuShop': phanHoiTuShop,
      'NgayDanhGia': ngayDanhGia.toIso8601String(),
      'AnDanh': anDanh ? 1 : 0,
    };
  }

  // Thêm phương thức chuyển đổi sang domain model
  Review toDomain() {
    return Review(
      id: maDG,
      accountId: maTK,
      productId: maSP,
      orderId: maDH ?? 0, // Giá trị mặc định nếu null
      rating: diem,
      comment: nhanXet,
      images: hinhAnh,
      shopReply: phanHoiTuShop,
      reviewDate: ngayDanhGia,
      isAnonymous: anDanh,
    );
  }
}