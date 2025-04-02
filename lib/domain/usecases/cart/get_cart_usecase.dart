import 'package:do_an_flutter/domain/entities/cart.dart';
import 'package:do_an_flutter/domain/entities/cart_detail.dart';
import 'package:do_an_flutter/domain/repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository cartRepository;

  GetCartUseCase(this.cartRepository);

  Future<(Cart, List<CartDetail>)> call(int accountId) async {
    try {
      final cart = await cartRepository.getCart(accountId);
      if (cart.cartId == null) {
        // return (cart, [""]); // Trả về giỏ hàng rỗng nếu không tìm thấy
      }
      final cartDetails = await cartRepository.getCartDetails(cart.cartId!);
      return (cart, cartDetails);
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }
}