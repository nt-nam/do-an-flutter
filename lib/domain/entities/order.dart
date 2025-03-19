enum OrderStatus {
  pending,
  delivering,
  delivered,
  cancelled,
}

class Order {
  final int id;
  final int? accountId;
  final int? cartId; // Liên kết với Cart
  final DateTime orderDate;
  final double totalAmount;
  final OrderStatus status; // 'Chờ xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'
  final String deliveryAddress;
  final int? offerId;

  Order({
    required this.id,
    this.accountId,
    this.cartId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.offerId,
  });
}