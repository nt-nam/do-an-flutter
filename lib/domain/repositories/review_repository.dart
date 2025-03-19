import '../../data/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<ReviewModel>> getReviews({
    int? productId,
    int? accountId, // Thêm accountId
    bool? onlyApproved,
  });

  Future<ReviewModel> addReview(ReviewModel review, {required int orderId});

  Future<ReviewModel> updateReview(ReviewModel review);

  Future<void> deleteReview(int reviewId);
}