import '../../entities/review.dart';
import '../../repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Review> call({
    required int productId,
    required int accountId,
    required int orderId,
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
        id: 0, // ID will be generated by backend
        accountId: accountId,
        productId: productId,
        orderId: orderId,
        rating: rating,
        comment: comment,
        images: images,
        shopReply: null,
        reviewDate: DateTime.now(),
        isAnonymous: isAnonymous,
      );
      return await repository.addReview(review: review, orderId: orderId);
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}