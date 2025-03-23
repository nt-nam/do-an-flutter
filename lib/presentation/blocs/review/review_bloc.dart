import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_reviews_usecase.dart';
import '../../../domain/usecases/update_review_usecase.dart';
import '../../../domain/usecases/delete_review_usecase.dart';
import '../../../domain/usecases/submit_review_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final SubmitReviewUseCase submitReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  ReviewBloc({
    required this.getReviewsUseCase,
    required this.submitReviewUseCase,
    required this.updateReviewUseCase,
    required this.deleteReviewUseCase,
  }) : super(const ReviewInitial()) {
    on<FetchReviewsEvent>(_onFetchReviews);
    on<FetchReviewDetailsEvent>(_onFetchReviewDetails);
    on<AddReviewEvent>(_onAddReview);
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
  }

  Future<void> _onFetchReviews(FetchReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(
        productId: event.productId,
        accountId: event.accountId, // Đã sửa ở trên
        onlyApproved: event.onlyApproved,
      );
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onFetchReviewDetails(FetchReviewDetailsEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      emit(const ReviewError('Fetch review details not implemented yet'));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      final review = await submitReviewUseCase(
        event.accountId, // Positional argument
        event.productId, // Positional argument
        event.rating,    // Positional argument
        event.orderId,   // Positional argument
        comment: event.comment, // Named argument
      );
      emit(ReviewAdded(review));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onUpdateReview(UpdateReviewEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      final review = await updateReviewUseCase(
        reviewId: event.reviewId,
        rating: event.rating,
        comment: event.comment,
        maHD: event.maHD,  // Add this
      );
      emit(ReviewUpdated(review));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onDeleteReview(DeleteReviewEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      await deleteReviewUseCase(reviewId: event.reviewId);
      emit(ReviewDeleted(event.reviewId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}