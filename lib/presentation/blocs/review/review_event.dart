abstract class ReviewEvent {
  const ReviewEvent();
}

class FetchReviewsEvent extends ReviewEvent {
  final int? productId;
  final int? accountId;
  final int? orderId;
  final bool? withImagesOnly;
  final bool? withShopReply;

  const FetchReviewsEvent({
    this.productId,
    this.accountId,
    this.orderId,
    this.withImagesOnly,
    this.withShopReply,
  });
}

class AddReviewEvent extends ReviewEvent {
  final int productId;
  final int accountId;
  final int orderId;
  final int rating;
  final String? comment;
  final List<String>? images;
  final bool isAnonymous;

  const AddReviewEvent({
    required this.productId,
    required this.accountId,
    required this.orderId,
    required this.rating,
    this.comment,
    this.images,
    this.isAnonymous = false,
  });
}

class UpdateReviewEvent extends ReviewEvent {
  final int reviewId;
  final int rating;
  final String? comment;
  final List<String>? images;
  final bool isAnonymous;

  const UpdateReviewEvent({
    required this.reviewId,
    required this.rating,
    this.comment,
    this.images,
    this.isAnonymous = false,
  });
}

class DeleteReviewEvent extends ReviewEvent {
  final int reviewId;

  const DeleteReviewEvent(this.reviewId);
}

class AddShopReplyEvent extends ReviewEvent {
  final int reviewId;
  final String reply;

  const AddShopReplyEvent({
    required this.reviewId,
    required this.reply,
  });
}