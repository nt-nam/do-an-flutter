import '../../entities/review.dart';
import '../../repositories/review_repository.dart';

class UpdateReviewUseCase {
  final ReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  Future<Review> call({
    required int reviewId,
    required int rating,
    String? comment,
    List<String>? images,
    bool isAnonymous = false,
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }
      final review = Review(
        id: reviewId,
        accountId: null, // Will be validated by backend
        productId: null, // Not updated
        orderId: 0, // Not updated
        rating: rating,
        comment: comment,
        images: images,
        shopReply: null, // Not updated by user
        reviewDate: DateTime.now(),
        isAnonymous: isAnonymous,
      );
      return await repository.updateReview(review);
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }
}