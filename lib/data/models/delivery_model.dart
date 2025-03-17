class DeliveryModel {
  final int maVC;
  final int? maDH; // Có thể null nếu đơn hàng bị xóa
  final int? maNVG; // Có thể null nếu chưa có nhân viên giao
  final DateTime? ngayGiao; // Có thể null nếu chưa giao
  final String trangThai; // ENUM: 'Chưa giao', 'Đang giao', 'Đã giao'

  DeliveryModel({
    required this.maVC,
    this.maDH,
    this.maNVG,
    this.ngayGiao,
    required this.trangThai,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      maVC: json['MaVC'] as int,
      maDH: json['MaDH'] as int?,
      maNVG: json['MaNVG'] as int?,
      ngayGiao: json['NgayGiao'] != null ? DateTime.parse(json['NgayGiao'] as String) : null,
      trangThai: json['TrangThai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaVC': maVC,
      'MaDH': maDH,
      'MaNVG': maNVG,
      'NgayGiao': ngayGiao?.toIso8601String(),
      'TrangThai': trangThai,
    };
  }
}