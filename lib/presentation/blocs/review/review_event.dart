abstract class ReviewEvent {
  const ReviewEvent();
}

class FetchReviewsEvent extends ReviewEvent {
  final int? productId; // Lọc theo sản phẩm nếu có
  final int accountId; // Lọc theo người dùng
  final bool? onlyApproved; // Lọc review đã duyệt (nếu có)

  const FetchReviewsEvent({
    this.productId,
    required this.accountId,
    this.onlyApproved,
  });
}

class FetchReviewDetailsEvent extends ReviewEvent {
  final int reviewId;

  const FetchReviewDetailsEvent(this.reviewId);
}

class AddReviewEvent extends ReviewEvent {
  final int productId;
  final int accountId;
  final int orderId;
  final double rating;
  final String comment;

  const AddReviewEvent({
    required this.productId,
    required this.accountId,
    required this.orderId,
    required this.rating,
    required this.comment,
  });
}

class UpdateReviewEvent extends ReviewEvent {
  final int reviewId;
  final int rating;
  final String comment;
  final int maHD;  // Add this

  const UpdateReviewEvent(this.reviewId, this.rating, this.comment, this.maHD);
}

class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;

  const DeleteReviewEvent(this.reviewId);
}
