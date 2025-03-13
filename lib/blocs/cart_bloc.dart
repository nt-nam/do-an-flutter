// lib/blocs/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

abstract class CartEvent {}
class AddToCartEvent extends CartEvent {
  final ProductModel product;
  AddToCartEvent(this.product);
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
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final currentState = state is CartUpdated ? (state as CartUpdated).items : <CartModel>[];
    final newItem = CartModel(id: currentState.length + 1, product: event.product, quantity: 1);
    emit(CartUpdated([...currentState, newItem]));

    // Khi dùng API thật (PHP/phpMyAdmin):
    // await http.post(
    //   Uri.parse('http://your-php-server/cart/add.php'),
    //   body: {'productId': event.product.id.toString(), 'quantity': '1'},
    // );
  }
}