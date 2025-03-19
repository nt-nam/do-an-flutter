import '../repositories/review_repository.dart';

class DeleteReviewUseCase {
  final ReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  Future<void> call({
    required int reviewId,
  }) async {
    try {
      await repository.deleteReview(reviewId);
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }
}