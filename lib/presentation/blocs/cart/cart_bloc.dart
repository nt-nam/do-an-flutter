import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/get_cart_usecase.dart';
import '../../../domain/usecases/remove_from_cart_usecase.dart';
import '../../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;

  CartBloc(
      this.getCartUseCase,
      this.addToCartUseCase,
      this.removeFromCartUseCase,
      this.updateCartQuantityUseCase,
      ) : super(const CartInitial()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartItems = await getCartUseCase(event.accountId);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartItem = await addToCartUseCase(event.accountId, event.productId, event.quantity);
      emit(CartItemAdded(cartItem));
      // Sau khi thêm, tải lại giỏ hàng
      final cartItems = await getCartUseCase(event.accountId);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await removeFromCartUseCase(event.cartId);
      emit(CartItemRemoved(event.cartId));
      // Tải lại giỏ hàng sau khi xóa
      final cartItems = await getCartUseCase((state as CartLoaded).cartItems.first.accountId!);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartItem = await updateCartQuantityUseCase(event.cartId, event.newQuantity);
      emit(CartItemUpdated(cartItem));
      // Tải lại giỏ hàng sau khi cập nhật
      final cartItems = await getCartUseCase((state as CartLoaded).cartItems.first.accountId!);
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}