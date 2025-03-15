// lib/models/notification_model.dart
import 'package:flutter/foundation.dart';

class NotificationModel {
  final int id; // Mã thông báo (MaThongBao)
  final String title; // Tiêu đề thông báo
  final String message; // Nội dung thông báo
  final DateTime createdAt; // Thời gian tạo
  final bool isRead; // Trạng thái đã đọc

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  // Tạo từ JSON (khi dùng API)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['MaThongBao'],
      title: json['TieuDe'],
      message: json['NoiDung'],
      createdAt: DateTime.parse(json['NgayTao']),
      isRead: json['DaDoc'] == 1,
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaThongBao': id,
      'TieuDe': title,
      'NoiDung': message,
      'NgayTao': createdAt.toIso8601String(),
      'DaDoc': isRead ? 1 : 0,
    };
  }
}