class Review {
  final int id;
  final int? accountId;
  final int? productId;
  final int orderId;
  final int rating; // Thay đổi từ double sang int (1-5)
  final String? comment;
  final List<String>? images; // Thêm trường hình ảnh
  final String? shopReply; // Thêm phản hồi từ shop
  final DateTime reviewDate;
  final bool isAnonymous; // Thêm trường ẩn danh

  Review({
    required this.id,
    this.accountId,
    this.productId,
    required this.orderId,
    required this.rating,
    this.comment,
    this.images,
    this.shopReply,
    required this.reviewDate,
    this.isAnonymous = false,
  });
}