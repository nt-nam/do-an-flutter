class OrderDetail {
  final int? id; // Cho phép null
  final int? orderId; // Cho phép null
  final int? productId; // Cho phép null
  final int? quantity; // Cho phép null
  final double? priceAtPurchase; // Cho phép null

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
  });
}