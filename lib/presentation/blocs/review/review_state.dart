import '../../../domain/entities/review.dart';

abstract class ReviewState {
  const ReviewState();
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  const ReviewsLoaded(this.reviews);
}

class ReviewDetailsLoaded extends ReviewState {
  final Review review;
  const ReviewDetailsLoaded(this.review);
}

class ReviewAdded extends ReviewState {
  final Review review;
  const ReviewAdded(this.review);
}

class ReviewUpdated extends ReviewState {
  final Review review;
  const ReviewUpdated(this.review);
}

class ReviewDeleted extends ReviewState {
  final int reviewId;
  const ReviewDeleted(this.reviewId);
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
}