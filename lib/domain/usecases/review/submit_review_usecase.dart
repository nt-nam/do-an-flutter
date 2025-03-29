import '../../entities/review.dart';
import '../../repositories/review_repository.dart';
import '../../repositories/order_repository.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/order_model.dart';

class SubmitReviewUseCase {
  final ReviewRepository repository;
  final OrderRepository orderRepository;

  SubmitReviewUseCase(this.repository, this.orderRepository);

  Future<Review> call(
      int accountId,
      int productId,
      double rating,
      int orderId,
      {String? comment}
      ) async {
    try {
      // Kiểm tra rating
      if (rating < 1 || rating > 5) {
        throw Exception('Rating must be between 1 and 5');
      }

      // Kiểm tra trạng thái đơn hàng
      final order = await orderRepository.getOrderById(orderId);
      if (order.trangThai != OrderStatus.delivered) {
        throw Exception('Cannot submit review: Order is not delivered yet');
      }

      // Kiểm tra quyền của người dùng
      if (order.maTK != accountId) {
        throw Exception('Cannot submit review: Order does not belong to this account');
      }

      // Kiểm tra xem sản phẩm có trong đơn hàng không
      final orderDetails = await orderRepository.getOrderDetails(orderId);
      final productInOrder = orderDetails.any((detail) => detail.maSP == productId);
      if (!productInOrder) {
        throw Exception('Cannot submit review: Product is not in this order');
      }

      // Kiểm tra đánh giá trùng lặp
      final existingReviews = await repository.getReviews(productId: productId);
      final hasReviewed = existingReviews.any(
            (review) => review.maTK == accountId && review.maDH == orderId,
      );
      if (hasReviewed) {
        throw Exception('You have already reviewed this product for this order');
      }

      // Tạo ReviewModel
      final reviewModel = ReviewModel(
        maDG: 0, // API sẽ sinh
        maTK: accountId,
        maSP: productId,
        diem: rating,
        nhanXet: comment,
        ngayDanhGia: DateTime.now(),
        maDH: orderId,
      );

      // Gửi đánh giá
      final result = await repository.addReview(reviewModel, orderId: orderId);
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
      orderId: model.maDH,
    );
  }
}