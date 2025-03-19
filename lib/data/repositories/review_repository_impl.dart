import '../models/review_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ApiService apiService;
  final AuthService authService;

  ReviewRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<ReviewModel>> getReviews({
    int? productId,
    int? accountId, // Thêm accountId
    bool? onlyApproved,
  }) async {
    final token = await authService.getToken();
    String endpoint = 'danhgia';
    List<String> queryParams = [];
    if (productId != null) {
      queryParams.add('MaSP=$productId');
    }
    if (accountId != null) {
      queryParams.add('MaTK=$accountId'); // Thêm MaTK vào query
    }
    if (onlyApproved != null && onlyApproved) {
      queryParams.add('Duyet=1');
    }
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }
    final data = await apiService.get(endpoint, token: token);
    return (data as List).map((json) => ReviewModel.fromJson(json)).toList();
  }

  @override
  Future<ReviewModel> addReview(ReviewModel review, {required int orderId}) async {
    final token = await authService.getToken();
    final data = await apiService.post(
      'danhgia?MaDH=$orderId',
      review.toJson(),
      token: token,
    );
    return ReviewModel.fromJson(data);
  }

  @override
  Future<ReviewModel> updateReview(ReviewModel review) async {
    final token = await authService.getToken();
    final data = await apiService.put(
      'danhgia/${review.maDG}',
      review.toJson(),
      token: token,
    );
    return ReviewModel.fromJson(data);
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    final token = await authService.getToken();
    await apiService.delete('danhgia/$reviewId', token: token);
  }
}