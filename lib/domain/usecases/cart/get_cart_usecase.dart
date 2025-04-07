import '../../entities/cart.dart';
import '../../entities/cart_detail.dart';
import '../../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository cartRepository;

  GetCartUseCase(this.cartRepository);

  Future<(Cart, List<CartDetail>)> call(int accountId) async {
    try {
      print('Fetching cart for account ID: $accountId');
      final cart = await cartRepository.getCart(accountId);
      print('Cart: $cart');
      if (cart.cartId == null) {
        print('No cart found for account ID: $accountId, returning empty cart details');
        return (cart, <CartDetail>[]); // Sửa ở đây: Chỉ định rõ kiểu List<CartDetail>
      }
      print('Fetching cart details for cart ID: ${cart.cartId}');
      final cartDetails = await cartRepository.getCartDetails(cart.cartId!);
      print('Cart details: $cartDetails');
      return (cart, cartDetails);
    } catch (e) {
      print('Error in GetCartUseCase: $e');
      throw Exception('Failed to get cart: $e');
    }
  }
}