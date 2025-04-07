class CartDetail {
  final int cartDetailId;
  final int cartId;
  final int accountId; // Thêm trường accountId
  final int productId;
  final int quantity;
  final String? createdDate;
  final String? productName;
  final double? productPrice;
  final String? productImage;

  CartDetail({
    required this.cartDetailId,
    required this.cartId,
    required this.accountId,
    required this.productId,
    required this.quantity,
    this.createdDate,
    this.productName,
    this.productPrice,
    this.productImage,
  });
}