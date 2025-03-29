class CartDetail {
  final int cartId;
  final int productId;
  final int quantity;
  final String? productName; // Thêm nếu cần
  final double? price;       // Thêm nếu cần
  final String? image;       // Thêm nếu cần

  CartDetail({
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.productName,
    this.price,
    this.image,
  });
}