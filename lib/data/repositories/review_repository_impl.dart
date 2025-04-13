import '../models/review_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/review_repository.dart';
import '../../domain/entities/review.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ApiService apiService;
  final AuthService authService;

  ReviewRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<Review>> getReviews({
    int? productId,
    int? accountId,
    int? orderId,
    bool? withImagesOnly,
    bool? withShopReply,
  }) async {
    final token = await authService.getToken();
    String endpoint = 'danhgia';
    List<String> queryParams = [];

    if (productId != null) queryParams.add('MaSP=$productId');
    if (accountId != null) queryParams.add('MaTK=$accountId');
    if (orderId != null) queryParams.add('MaDH=$orderId');
    if (withImagesOnly != null && withImagesOnly) queryParams.add('CoAnh=1');
    if (withShopReply != null && withShopReply) queryParams.add('CoPhanHoi=1');

    if (queryParams.isNotEmpty) endpoint += '?${queryParams.join('&')}';

    final data = await apiService.get(endpoint, token: token);
    return (data as List)
        .map((json) => ReviewModel.fromJson(json).toDomain())
        .toList();
  }

  @override
  Future<Review> addReview({
    required Review review,
    required int orderId,
  }) async {
    final token = await authService.getToken();
    final reviewModel = ReviewModel(
      maDG: 0, // ID sẽ được tạo tự động
      maTK: review.accountId,
      maSP: review.productId,
      maDH: orderId,
      diem: review.rating,
      nhanXet: review.comment,
      hinhAnh: review.images,
      phanHoiTuShop: null,
      ngayDanhGia: review.reviewDate,
      anDanh: review.isAnonymous,
    );

    final data = await apiService.post(
      'danhgia',
      reviewModel.toJson(),
      token: token,
    );
    return ReviewModel.fromJson(data).toDomain();
  }

  @override
  Future<Review> updateReview(Review review) async {
    final token = await authService.getToken();
    final reviewModel = ReviewModel(
      maDG: review.id,
      maTK: review.accountId,
      maSP: review.productId,
      maDH: review.orderId,
      diem: review.rating,
      nhanXet: review.comment,
      hinhAnh: review.images,
      phanHoiTuShop: review.shopReply,
      ngayDanhGia: review.reviewDate,
      anDanh: review.isAnonymous,
    );

    final data = await apiService.put(
      'danhgia/${review.id}',
      reviewModel.toJson(),
      token: token,
    );
    return ReviewModel.fromJson(data).toDomain();
  }

  @override
  Future<void> deleteReview(int reviewId) async {
    final token = await authService.getToken();
    await apiService.delete('danhgia/$reviewId', token: token);
  }

  @override
  Future<void> addShopReply({
    required int reviewId,
    required String reply,
  }) async {
    final token = await authService.getToken();
    // Using put as a fallback since patch is not available
    await apiService.put(
      'danhgia/$reviewId',
      {'PhanHoiTuShop': reply},
      token: token,
    );
  }
}