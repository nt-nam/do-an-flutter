import '../../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository cartRepository;

  RemoveFromCartUseCase(this.cartRepository);

  Future<void> call(int cartDetailId) async {
    await cartRepository.removeFromCart(cartDetailId);
  }
}