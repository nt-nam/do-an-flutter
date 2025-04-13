import '../../repositories/review_repository.dart';

class AddShopReplyUseCase {
  final ReviewRepository repository;

  AddShopReplyUseCase(this.repository);

  Future<void> call({
    required int reviewId,
    required String reply,
  }) async {
    try {
      if (reply.isEmpty) {
        throw Exception('Reply cannot be empty');
      }
      await repository.addShopReply(reviewId: reviewId, reply: reply);
    } catch (e) {
      throw Exception('Failed to add shop reply: $e');
    }
  }
}