class CartDetail {
  final int? cartId; // Thay required thành optional
  final int productId;
  final int quantity;
  final String? productName;
  final double? price;
  final String? image;

  CartDetail({
    this.cartId, // Không còn required
    required this.productId,
    required this.quantity,
    this.productName,
    this.price,
    this.image,
  });
}