class CartDetail {
  final int cartId; // Liên kết với Cart
  final int productId;
  final int quantity;

  CartDetail({
    required this.cartId,
    required this.productId,
    required this.quantity,
  });
}