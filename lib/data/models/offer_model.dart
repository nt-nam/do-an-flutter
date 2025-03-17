class OfferModel {
  final int maUD;
  final String tenUD;
  final double mucGiam; // % hoặc số tiền giảm
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final String trangThai; // ENUM: 'Hoạt động', 'Hết hạn'

  OfferModel({
    required this.maUD,
    required this.tenUD,
    required this.mucGiam,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.trangThai,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      maUD: json['MaUD'] as int,
      tenUD: json['TenUD'] as String,
      mucGiam: (json['MucGiam'] as num).toDouble(),
      ngayBatDau: DateTime.parse(json['NgayBatDau'] as String),
      ngayKetThuc: DateTime.parse(json['NgayKetThuc'] as String),
      trangThai: json['TrangThai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaUD': maUD,
      'TenUD': tenUD,
      'MucGiam': mucGiam,
      'NgayBatDau': ngayBatDau.toIso8601String(),
      'NgayKetThuc': ngayKetThuc.toIso8601String(),
      'TrangThai': trangThai,
    };
  }
}