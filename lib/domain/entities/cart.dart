class Cart {
  final int id;
  final int? accountId; // Có thể null nếu tài khoản bị xóa
  final int? productId; // Có thể null nếu sản phẩm bị xóa
  final int quantity;
  final DateTime addedDate;

  Cart({
    required this.id,
    this.accountId,
    this.productId,
    required this.quantity,
    required this.addedDate,
  });
}