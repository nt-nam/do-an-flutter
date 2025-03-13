// lib/models/cart_model.dart
import 'package:flutter/foundation.dart'; // Để dùng @required
import 'product_model.dart';

class CartModel {
  final int id; // Mã giỏ hàng (MaGH)
  final ProductModel product; // Sản phẩm trong giỏ
  final int quantity; // Số lượng

  CartModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  // Factory để tạo từ JSON (khi dùng API thật)
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['MaGH'],
      product: ProductModel.fromJson(json['product']), // Giả định API trả về object product
      quantity: json['SoLuong'],
    );
  }

  // Chuyển đổi thành JSON (khi gửi dữ liệu lên API)
  Map<String, dynamic> toJson() {
    return {
      'MaGH': id,
      'MaSP': product.id, // Chỉ gửi MaSP thay vì toàn bộ product khi thêm vào giỏ
      'SoLuong': quantity,
    };
  }

  // Tính tổng tiền cho mục này
  double get totalPrice => product.price * quantity;
}