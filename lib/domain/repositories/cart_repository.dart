import '../../data/models/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> getCartItems(int accountId);
  Future<CartModel> addToCart(CartModel cartItem);
  Future<CartModel> updateCartItem(CartModel cartItem);
  Future<void> removeFromCart(int cartId);
}