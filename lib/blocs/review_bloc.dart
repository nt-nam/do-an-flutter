// lib/blocs/review_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/review_model.dart';

abstract class ReviewEvent {}
class LoadReviewsEvent extends ReviewEvent {
  final int productId;
  LoadReviewsEvent(this.productId);
}
class SubmitReviewEvent extends ReviewEvent {
  final int productId;
  final int rating;
  final String comment;
  SubmitReviewEvent(this.productId, this.rating, this.comment);
}

abstract class ReviewState {}
class ReviewInitial extends ReviewState {}
class ReviewLoading extends ReviewState {}
class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  ReviewLoaded(this.reviews);
}
class ReviewSubmitted extends ReviewState {
  final ReviewModel review;
  ReviewSubmitted(this.review);
}
class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  List<ReviewModel> _reviews = []; // Mock danh sách đánh giá

  ReviewBloc() : super(ReviewInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<SubmitReviewEvent>(_onSubmitReview);
  }

  Future<void> _onLoadReviews(LoadReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      // Mock: Tạo dữ liệu giả lập
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      _reviews = _reviews.where((r) => r.productId == event.productId).toList();
      if (_reviews.isEmpty && event.productId == 1) {
        _reviews = [
          ReviewModel(
            id: 1,
            productId: 1,
            userId: 1,
            userName: 'Nguyễn Văn A',
            rating: 4,
            comment: 'Sản phẩm tốt, giao hàng nhanh',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
          ),
        ];
      }
      emit(ReviewLoaded(_reviews));

      // Khi dùng API thật (PHP):
      // final response = await http.get(Uri.parse('http://your-php-server/reviews/list.php?MaSP=${event.productId}'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> json = jsonDecode(response.body);
      //   _reviews = json.map((data) => ReviewModel.fromJson(data)).toList();
      //   emit(ReviewLoaded(_reviews));
      // } else {
      //   throw Exception('Không tải được đánh giá');
      // }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onSubmitReview(SubmitReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      // Mock: Tạo đánh giá mới
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      final review = ReviewModel(
        id: _reviews.length + 1,
        productId: event.productId,
        userId: 1, // Mock userId
        userName: 'Người dùng hiện tại', // Mock userName
        rating: event.rating,
        comment: event.comment,
        createdAt: DateTime.now(),
      );
      _reviews.add(review);
      emit(ReviewSubmitted(review));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/reviews/submit.php'),
      //   body: jsonEncode({
      //     'MaSP': event.productId,
      //     'MaTK': 1, // Lấy từ AuthBloc khi có API
      //     'DiemDanhGia': event.rating,
      //     'BinhLuan': event.comment,
      //   }),
      // );
      // if (response.statusCode == 201) {
      //   emit(ReviewSubmitted(ReviewModel.fromJson(jsonDecode(response.body))));
      // } else {
      //   throw Exception('Không thể gửi đánh giá');
      // }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}