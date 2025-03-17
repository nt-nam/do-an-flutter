import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(int cartId) async {
    try {
      await repository.removeFromCart(cartId);
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }
}