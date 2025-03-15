// lib/models/review_model.dart
import 'package:flutter/foundation.dart';

class ReviewModel {
  final int id; // Mã đánh giá (MaDanhGia)
  final int productId; // Mã sản phẩm (MaSP)
  final int userId; // Mã người dùng (MaTK)
  final String userName; // Tên người dùng
  final int rating; // Điểm đánh giá (1-5)
  final String comment; // Bình luận
  final DateTime createdAt; // Thời gian tạo

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Tạo từ JSON (khi dùng API)
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['MaDanhGia'],
      productId: json['MaSP'],
      userId: json['MaTK'],
      userName: json['TenNguoiDung'],
      rating: json['DiemDanhGia'],
      comment: json['BinhLuan'],
      createdAt: DateTime.parse(json['NgayTao']),
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaDanhGia': id,
      'MaSP': productId,
      'MaTK': userId,
      'TenNguoiDung': userName,
      'DiemDanhGia': rating,
      'BinhLuan': comment,
      'NgayTao': createdAt.toIso8601String(),
    };
  }
}