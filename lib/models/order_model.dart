// lib/models/order_model.dart
import 'package:flutter/foundation.dart';
import 'cart_model.dart';

class OrderModel {
  final int id; // Mã đơn hàng (MaDH)
  final List<CartModel> items; // Danh sách sản phẩm trong đơn hàng
  final double total; // Tổng tiền
  final String status; // Trạng thái: pending, confirmed, shipped, delivered, cancelled
  final DateTime createdAt; // Thời gian tạo
  final String? address; // Địa chỉ giao hàng

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    this.address,
  });

  // Tính tổng tiền từ danh sách sản phẩm
  factory OrderModel.fromCart(List<CartModel> cartItems, {String? address}) {
    final total = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    return OrderModel(
      id: DateTime.now().millisecondsSinceEpoch, // Mock ID tạm thời
      items: cartItems,
      total: total,
      status: 'pending',
      createdAt: DateTime.now(),
      address: address,
    );
  }

  // Chuyển từ JSON (khi dùng API)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['MaDH'],
      items: (json['items'] as List).map((item) => CartModel.fromJson(item)).toList(),
      total: json['TongTien'].toDouble(),
      status: json['TrangThai'],
      createdAt: DateTime.parse(json['NgayTao']),
      address: json['DiaChi'],
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaDH': id,
      'items': items.map((item) => item.toJson()).toList(),
      'TongTien': total,
      'TrangThai': status,
      'NgayTao': createdAt.toIso8601String(),
      'DiaChi': address,
    };
  }
}