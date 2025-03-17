import '../entities/review.dart';
import '../repositories/review_repository.dart';
import '../../data/models/review_model.dart';

class SubmitReviewUseCase {
  final ReviewRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<Review> call(int accountId, int productId, double rating, {String? comment}) async {
    try {
      if (rating < 1 || rating > 5) throw Exception('Rating must be between 1 and 5');
      final reviewModel = ReviewModel(
        maDG: 0,
        maTK: accountId,
        maSP: productId,
        diem: rating,
        nhanXet: comment,
        ngayDanhGia: DateTime.now(),
      );
      final result = await repository.addReview(reviewModel);
      return _mapToEntity(result);
    } catch (e) {
      throw Exception('Failed to submit review: $e');
    }
  }

  Review _mapToEntity(ReviewModel model) {
    return Review(
      id: model.maDG,
      accountId: model.maTK,
      productId: model.maSP,
      rating: model.diem,
      comment: model.nhanXet,
      reviewDate: model.ngayDanhGia,
    );
  }
}