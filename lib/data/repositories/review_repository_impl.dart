import '../models/review_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ApiService apiService;
  final AuthService authService;

  ReviewRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<ReviewModel>> getReviews(int productId) async {
    final token = await authService.getToken();
    final data = await apiService.get('danhgia?MaSP=$productId', token: token);
    return (data as List).map((json) => ReviewModel.fromJson(json)).toList();
  }

  @override
  Future<ReviewModel> addReview(ReviewModel review) async {
    final token = await authService.getToken();
    final data = await apiService.post('danhgia', review.toJson(), token: token);
    return ReviewModel.fromJson(data);
  }
}