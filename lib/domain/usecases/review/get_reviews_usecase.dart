import '../../entities/review.dart';
import '../../repositories/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  Future<List<Review>> call({
    int? productId,
    int? accountId,
    int? orderId,
    bool? withImagesOnly,
    bool? withShopReply,
  }) async {
    try {
      return await repository.getReviews(
        productId: productId,
        accountId: accountId,
        orderId: orderId,
        withImagesOnly: withImagesOnly,
        withShopReply: withShopReply,
      );
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }
}