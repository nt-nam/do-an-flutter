import '../entities/review.dart';
import '../repositories/review_repository.dart';
import '../../data/models/review_model.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Review> call({
    required int productId,
    required int accountId,
    required int orderId,
    required int rating,
    required String comment,
  }) async {
    try {
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }
      final reviewModel = ReviewModel(
        maDG: 0, // API sẽ sinh mã
        maTK: accountId,
        maSP: productId,
        diem: rating.toDouble(),
        nhanXet: comment,
        ngayDanhGia: DateTime.now(),
        maDH: orderId
      );
      final result = await repository.addReview(reviewModel, orderId: orderId);
      return Review(
        id: result.maDG,
        accountId: result.maTK,
        productId: result.maSP,
        rating: result.diem,
        comment: result.nhanXet,
        reviewDate: result.ngayDanhGia,
        orderId: orderId, // Truyền orderId từ tham số
      );
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}