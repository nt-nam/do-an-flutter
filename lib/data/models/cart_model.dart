import '../../domain/entities/cart.dart';
class CartModel {
  final int cartId;
  final int accountId;
  final DateTime addedDate;

  CartModel({
    required this.cartId,
    required this.accountId,
    required this.addedDate,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final cartId = json['MaGH'];
    if (cartId == null || cartId == 0) {
      throw Exception('Invalid cart ID received from API');
    }
    if (json.containsKey('status')) {
      print('Status field in json: ${json['status']} (${json['status'].runtimeType})');
    }


    return CartModel(
      cartId: cartId,
      accountId: json['MaTK'] ?? 0,
      addedDate: DateTime.parse(json['NgayThem'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaGH': cartId,
      'MaTK': accountId,
      'NgayThem': addedDate.toIso8601String(),
    };
  }

  Cart toEntity() {
    return Cart(
      cartId: cartId,
      accountId: accountId,
      addedDate: addedDate,

    );
  }
}