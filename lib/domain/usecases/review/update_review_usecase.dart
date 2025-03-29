import '../../entities/review.dart';
import '../../repositories/review_repository.dart';
import '../../../data/models/review_model.dart';

class UpdateReviewUseCase {
  final ReviewRepository repository;

  UpdateReviewUseCase(this.repository);

  Future<Review> call({
    required int reviewId,
    required int rating,
    required String comment,
    required int maHD
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }
      final reviewModel = ReviewModel(
        maDG: reviewId,
        maTK: null,
        maSP: null,
        diem: rating.toDouble(),
        nhanXet: comment,
        ngayDanhGia: DateTime.now(),
        maDH: maHD,
      );
      final result = await repository.updateReview(reviewModel);
      return Review(
        id: result.maDG,
        accountId: result.maTK,
        productId: result.maSP,
        rating: result.diem,
        comment: result.nhanXet,
        reviewDate: result.ngayDanhGia,
        orderId: null,
      );
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }
}