import 'package:do_an_flutter/domain/entities/offer.dart'; // Import OfferStatus từ domain

class OfferModel {
  final int maUD;
  final String tenUD;
  final double mucGiam;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final OfferStatus trangThai; // Dùng OfferStatus từ domain

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
      maUD: json['MaUD'],
      tenUD: json['TenUD'],
      mucGiam: json['MucGiam'].toDouble(),
      ngayBatDau: DateTime.parse(json['NgayBatDau']),
      ngayKetThuc: DateTime.parse(json['NgayKetThuc']),
      trangThai: OfferStatus.values.firstWhere((e) => e.name == json['TrangThai']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaUD': maUD,
      'TenUD': tenUD,
      'MucGiam': mucGiam,
      'NgayBatDau': ngayBatDau.toIso8601String(),
      'NgayKetThuc': ngayKetThuc.toIso8601String(),
      'TrangThai': trangThai.name,
    };
  }
}