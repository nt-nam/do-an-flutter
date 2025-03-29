import '../../entities/review.dart';
import '../../repositories/review_repository.dart';
import '../../../data/models/review_model.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  Future<List<Review>> call({
    int? productId,
    int? accountId, // Thêm accountId
    bool? onlyApproved,
  }) async {
    final reviewModels = await repository.getReviews(
      productId: productId,
      accountId: accountId, // Truyền accountId
      onlyApproved: onlyApproved,
    );
    return reviewModels.map((model) => _mapToEntity(model)).toList();
  }

  Review _mapToEntity(ReviewModel model) {
    return Review(
      id: model.maDG,
      accountId: model.maTK,
      productId: model.maSP,
      rating: model.diem,
      comment: model.nhanXet,
      reviewDate: model.ngayDanhGia,
      orderId: model.maDH,
    );
  }
}