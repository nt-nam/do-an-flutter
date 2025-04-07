import '../../domain/entities/offer.dart';

class OfferModel {
  final String maUD;
  final String tenUD;
  final double mucGiam;
  final DiscountType discountType;
  final double? hoadonMin;
  final String? masp;
  final String? loaisp;
  final DateTime? ngayBatDau;
  final DateTime? ngayKetThuc;
  final OfferStatus trangThai;
  final String? ghiChu;
  final int? soLanMax;
  final int? gioiHanKhach;
  final DateTime? ngayTao;
  final double? giaTriMax;

  OfferModel({
    required this.maUD,
    required this.tenUD,
    required this.mucGiam,
    required this.discountType,
    this.hoadonMin,
    this.masp,
    this.loaisp,
    this.ngayBatDau,
    this.ngayKetThuc,
    required this.trangThai,
    this.ghiChu,
    this.soLanMax,
    this.gioiHanKhach,
    this.ngayTao,
    this.giaTriMax,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final mucGiam = json['giatri'] != null ? double.tryParse(json['giatri'].toString()) ?? 0.0 : 0.0;
    return OfferModel(
      maUD: json['ma_uudai'],
      tenUD: json['ten'],
      mucGiam: mucGiam,
      discountType: mucGiam < 0 ? DiscountType.amount : DiscountType.percentage,
      hoadonMin: json['hoadon_min'] != null ? double.tryParse(json['hoadon_min'].toString()) ?? 0.0 : null,
      masp: json['masp'],
      loaisp: json['loaisp'],
      ngayBatDau: json['tg_batdau'] != null ? DateTime.parse(json['tg_batdau']) : null,
      ngayKetThuc: json['tg_ketthuc'] != null ? DateTime.parse(json['tg_ketthuc']) : null,
      trangThai: json['status'] == 'ACTIVE' ? OfferStatus.active : OfferStatus.inactive,
      ghiChu: json['ghichu'],
      soLanMax: json['solan_max'] != null ? int.tryParse(json['solan_max'].toString()) : null, // Chuyển String sang int
      gioiHanKhach: json['gioihan_khach'] != null ? int.tryParse(json['gioihan_khach'].toString()) : null, // Chuyển String sang int
      ngayTao: json['ngaytao'] != null ? DateTime.parse(json['ngaytao']) : null,
      giaTriMax: json['giatri_max'] != null ? double.tryParse(json['giatri_max'].toString()) ?? 0.0 : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ma_uudai': maUD,
      'ten': tenUD,
      'giatri': mucGiam,
      'hoadon_min': hoadonMin,
      'masp': masp,
      'loaisp': loaisp,
      'tg_batdau': ngayBatDau?.toIso8601String(),
      'tg_ketthuc': ngayKetThuc?.toIso8601String(),
      'status': trangThai == OfferStatus.active ? 'ACTIVE' : 'INACTIVE',
      'ghichu': ghiChu,
      'solan_max': soLanMax,
      'gioihan_khach': gioiHanKhach,
      'giatri_max': giaTriMax,
    };
  }
}