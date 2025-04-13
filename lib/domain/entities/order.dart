enum OrderStatus {
  pending,
  delivering,
  delivered,
  cancelled,
}

class Order {
  final int? id; // Cho phép null
  final int? accountId; // Cho phép null
  final int? cartId;
  final DateTime orderDate;
  final double totalAmount;
  final OrderStatus status;
  final String? deliveryAddress;
  final String? offerId;

  Order({
    required this.id,
    required this.accountId,
    this.cartId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    this.deliveryAddress,
    this.offerId,
  });
}