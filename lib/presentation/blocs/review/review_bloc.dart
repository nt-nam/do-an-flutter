import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/review/add_review_usecase.dart';
import '../../../domain/usecases/review/get_reviews_usecase.dart';
import '../../../domain/usecases/review/update_review_usecase.dart';
import '../../../domain/usecases/review/delete_review_usecase.dart';
import '../../../domain/usecases/review/add_shop_reply_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;
  final AddShopReplyUseCase addShopReplyUseCase;

  ReviewBloc({
    required this.getReviewsUseCase,
    required this.addReviewUseCase,
    required this.updateReviewUseCase,
    required this.deleteReviewUseCase,
    required this.addShopReplyUseCase,
  }) : super(const ReviewInitial()) {
    on<FetchReviewsEvent>(_onFetchReviews);
    on<AddReviewEvent>(_onAddReview);
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<AddShopReplyEvent>(_onAddShopReply);
  }

  Future<void> _onFetchReviews(FetchReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(
        productId: event.productId,
        accountId: event.accountId,
        orderId: event.orderId,
        withImagesOnly: event.withImagesOnly,
        withShopReply: event.withShopReply,
      );
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      final review = await addReviewUseCase(
        productId: event.productId,
        accountId: event.accountId,
        orderId: event.orderId,
        rating: event.rating,
        comment: event.comment,
        images: event.images,
        isAnonymous: event.isAnonymous,
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
        images: event.images,
        isAnonymous: event.isAnonymous,
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

  Future<void> _onAddShopReply(AddShopReplyEvent event, Emitter<ReviewState> emit) async {
    emit(const ReviewLoading());
    try {
      await addShopReplyUseCase(
        reviewId: event.reviewId,
        reply: event.reply,
      );
      emit(ShopReplyAdded(event.reviewId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}