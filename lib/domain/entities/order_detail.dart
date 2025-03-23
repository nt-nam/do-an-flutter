class OrderDetail {
  final int id; // Thêm khóa chính riêng
  final int orderId;
  final int productId;
  final int quantity;
  final double priceAtPurchase;

  OrderDetail({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
  });
}