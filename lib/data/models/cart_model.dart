import 'package:do_an_flutter/domain/entities/cart.dart';

class CartModel {
  final int cartId;
  final int accountId;
  final DateTime addedDate;
  final String status;

  CartModel({
    required this.cartId,
    required this.accountId,
    required this.addedDate,
    required this.status,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cartId = json['MaGH'];
    if (cartId == null || cartId == 0) {
      throw Exception('Invalid cart ID received from API');
    }

    return CartModel(
      cartId: cartId,
      accountId: json['MaTK'] ?? 0,
      addedDate: DateTime.parse(json['NgayThem'] ?? DateTime.now().toString()),
      status: json['TrangThai'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': cartId,
      'MaTK': accountId,
      'NgayThem': addedDate.toIso8601String(),
      'TrangThai': status,
    };
  }

  Cart toEntity() {
    return Cart(
      cartId: cartId,
      accountId: accountId,
      addedDate: addedDate,
      status: status,
    );
  }
}