import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart_detail.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final List<CartDetail> cartItems;

  const CartLoaded({required this.cartItems});

  @override
  List<Object?> get props => [cartItems];
}

class CartItemAdded extends CartState {
  final CartDetail cartItem;

  const CartItemAdded(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartItemRemoved extends CartState {
  final int cartId;

  const CartItemRemoved(this.cartId);

  @override
  List<Object?> get props => [cartId];
}

class CartItemUpdated extends CartState {
  final CartDetail cartItem;

  const CartItemUpdated(this.cartItem);

  @override
  List<Object?> get props => [cartItem];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}