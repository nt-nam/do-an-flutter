// lib/models/delivery_model.dart
import 'package:flutter/foundation.dart';

class DeliveryModel {
  final int orderId; // Mã đơn hàng (MaDH)
  final String status; // Trạng thái: preparing, shipping, delivered
  final DateTime? updatedAt; // Thời gian cập nhật trạng thái
  final String? location; // Vị trí hiện tại (mock)

  DeliveryModel({
    required this.orderId,
    required this.status,
    this.updatedAt,
    this.location,
  });

  // Tạo từ JSON (khi dùng API)
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      orderId: json['MaDH'],
      status: json['TrangThai'],
      updatedAt: json['ThoiGianCapNhat'] != null ? DateTime.parse(json['ThoiGianCapNhat']) : null,
      location: json['ViTri'],
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaDH': orderId,
      'TrangThai': status,
      'ThoiGianCapNhat': updatedAt?.toIso8601String(),
      'ViTri': location,
    };
  }
}