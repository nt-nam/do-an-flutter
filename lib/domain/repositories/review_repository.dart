import '../../data/models/review_model.dart';

abstract class ReviewRepository {
  Future<List<ReviewModel>> getReviews(int productId);
  Future<ReviewModel> addReview(ReviewModel review);
}