// lib/models/promotion_model.dart
import 'package:flutter/foundation.dart';

class PromotionModel {
  final int id; // Mã ưu đãi (MaUuDai)
  final String code; // Mã giảm giá (ví dụ: "DISCOUNT10")
  final String name; // Tên ưu đãi
  final double discount; // Giảm giá (% hoặc số tiền cố định)
  final bool isPercentage; // true nếu giảm theo %, false nếu giảm số tiền cố định
  final DateTime? expiryDate; // Ngày hết hạn

  PromotionModel({
    required this.id,
    required this.code,
    required this.name,
    required this.discount,
    required this.isPercentage,
    this.expiryDate,
  });

  // Tạo từ JSON (khi dùng API)
  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['MaUuDai'],
      code: json['MaGiamGia'],
      name: json['TenUuDai'],
      discount: json['GiamGia'].toDouble(),
      isPercentage: json['LaPhanTram'] == 1,
      expiryDate: json['NgayHetHan'] != null ? DateTime.parse(json['NgayHetHan']) : null,
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaUuDai': id,
      'MaGiamGia': code,
      'TenUuDai': name,
      'GiamGia': discount,
      'LaPhanTram': isPercentage ? 1 : 0,
      'NgayHetHan': expiryDate?.toIso8601String(),
    };
  }

  // Tính số tiền giảm dựa trên tổng đơn hàng
  double applyDiscount(double total) {
    if (isPercentage) {
      return total * (discount / 100);
    }
    return discount;
  }
}