// lib/blocs/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

abstract class CartEvent {}
class AddToCartEvent extends CartEvent {
  final ProductModel product;
  AddToCartEvent(this.product);
}
class UpdateQuantityEvent extends CartEvent {
  final int cartId;
  final int newQuantity;
  UpdateQuantityEvent(this.cartId, this.newQuantity);
}
class RemoveFromCartEvent extends CartEvent {
  final int cartId;
  RemoveFromCartEvent(this.cartId);
}

abstract class CartState {}
class CartInitial extends CartState {}
class CartUpdated extends CartState {
  final List<CartModel> items;
  CartUpdated(this.items);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final currentState = state is CartUpdated ? (state as CartUpdated).items : <CartModel>[];
    final newItem = CartModel(
      id: currentState.length + 1, // Mock ID
      product: event.product,
      quantity: 1,
    );
    emit(CartUpdated([...currentState, newItem]));
    // Khi dùng API thật (PHP):
    // await http.post(Uri.parse('http://your-php-server/cart/add.php'), body: newItem.toJson());
  }

  Future<void> _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) async {
    final currentState = state is CartUpdated ? (state as CartUpdated).items : <CartModel>[];
    final updatedItems = currentState.map((item) {
      if (item.id == event.cartId) {
        return CartModel(id: item.id, product: item.product, quantity: event.newQuantity);
      }
      return item;
    }).toList();
    emit(CartUpdated(updatedItems));
    // Khi dùng API thật (PHP):
    // await http.put(Uri.parse('http://your-php-server/cart/update.php'), body: {'MaGH': event.cartId, 'SoLuong': event.newQuantity});
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final currentState = state is CartUpdated ? (state as CartUpdated).items : <CartModel>[];
    final updatedItems = currentState.where((item) => item.id != event.cartId).toList();
    emit(CartUpdated(updatedItems));
    // Khi dùng API thật (PHP):
    // await http.delete(Uri.parse('http://your-php-server/cart/remove.php?MaGH=${event.cartId}'));
  }
}