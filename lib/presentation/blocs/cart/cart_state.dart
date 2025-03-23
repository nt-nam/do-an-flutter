import '../../../domain/entities/cart_detail.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartDetail> cartItems;

  const CartLoaded(this.cartItems);
}

class CartItemAdded extends CartState {
  final CartDetail cartItem;

  const CartItemAdded(this.cartItem);
}

class CartItemRemoved extends CartState {
  final int cartId;

  const CartItemRemoved(this.cartId);
}

class CartItemUpdated extends CartState {
  final CartDetail cartItem;

  const CartItemUpdated(this.cartItem);
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);
}