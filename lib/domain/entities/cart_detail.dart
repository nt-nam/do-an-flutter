class CartDetail {
  final int cartDetailId;
  final int cartId;
  final int productId;
  final int quantity;
  final double price;
  final String? productName;
  final double productPrice;
  final String? productImage;

  CartDetail({
    required this.cartDetailId,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
    this.productName,
    required this.productPrice,
    this.productImage,
  });
}