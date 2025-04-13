import '../../domain/entities/review.dart';

abstract class ReviewRepository {
  Future<List<Review>> getReviews({
    int? productId,
    int? accountId,
    int? orderId,
    bool? withImagesOnly,
    bool? withShopReply,
  });

  Future<Review> addReview({
    required Review review,
    required int orderId,
  });

  Future<Review> updateReview(Review review);

  Future<void> deleteReview(int reviewId);

  Future<void> addShopReply({
    required int reviewId,
    required String reply,
  });
}