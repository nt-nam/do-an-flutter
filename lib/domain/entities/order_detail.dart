class OrderDetail {
  final int orderId;
  final int productId;
  final int quantity;
  final double priceAtPurchase;

  OrderDetail({
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
  });
}