
import '../entities/cart.dart';
import '../entities/cart_detail.dart';

abstract class CartRepository {
  Future<Cart> getCart(int accountId);
  Future<List<CartDetail>> getCartDetails(int cartId);
  Future<CartDetail> addToCart(CartDetail cartDetail);
  Future<CartDetail> updateCartDetail(CartDetail cartDetail);
  Future<void> removeFromCart(int cartDetailId);
  Future<void> clearCart(int accountId);
}