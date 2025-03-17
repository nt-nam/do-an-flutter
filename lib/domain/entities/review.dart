class Review {
  final int id;
  final int? accountId; // Có thể null nếu tài khoản bị xóa
  final int? productId; // Có thể null nếu sản phẩm bị xóa
  final double rating; // Từ 1 đến 5
  final String? comment; // Có thể null
  final DateTime reviewDate;

  Review({
    required this.id,
    this.accountId,
    this.productId,
    required this.rating,
    this.comment,
    required this.reviewDate,
  });
}