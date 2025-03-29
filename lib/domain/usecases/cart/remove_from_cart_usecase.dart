import '../../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<void> call(int cartId, int productId) async {
    try {
      await repository.removeFromCart(cartId); // Giả định API cần cartId và productId
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }
}