import '../../domain/entities/order_detail.dart';

class OrderDetailModel {
  final int? maCTDH;
  final int? maDH;
  final int? maSP;
  final int? soLuong;
  final double? donGia; // Sửa từ giaLucMua thành donGia để khớp với API

  OrderDetailModel({
    this.maCTDH,
    this.maDH,
    this.maSP,
    this.soLuong,
    this.donGia,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      maCTDH: json['MaCTDH'] as int?,
      maDH: json['MaDH'] as int?,
      maSP: json['MaSP'] as int?,
      soLuong: json['SoLuong'] as int?,
      donGia: (json['DONGIA'] as num?)?.toDouble(), // Sửa từ GiaLucMua thành DONGIA
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaCTDH': maCTDH,
      'MaDH': maDH,
      'MaSP': maSP,
      'SoLuong': soLuong,
      'DONGIA': donGia, // Sửa từ GiaLucMua thành DONGIA
    };
  }
}