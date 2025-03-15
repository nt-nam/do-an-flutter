// lib/models/inventory_model.dart
import 'package:flutter/foundation.dart';
import 'product_model.dart';

class InventoryModel {
  final int productId; // Mã sản phẩm (MaSP)
  final ProductModel product; // Thông tin sản phẩm
  final int quantity; // Số lượng tồn kho

  InventoryModel({
    required this.productId,
    required this.product,
    required this.quantity,
  });

  // Tạo từ JSON (khi dùng API)
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      productId: json['MaSP'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['SoLuong'],
    );
  }

  // Chuyển thành JSON (khi gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaSP': productId,
      'SoLuong': quantity,
    };
  }
}