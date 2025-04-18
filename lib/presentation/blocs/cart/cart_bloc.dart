import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/cart_detail.dart';
import '../../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cart_usecase.dart';
import '../../../domain/usecases/cart/remove_from_cart_usecase.dart';
import '../../../domain/usecases/cart/update_cart_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  int? _accountId;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartQuantityUseCase,
  }) : super(const CartInitial()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final (cart, cartDetails) = await getCartUseCase(event.accountId);
      _accountId = event.accountId; // accountId có thể là null, nhưng _accountId đã khai báo là int?
      emit(CartLoaded(cartItems: cartDetails));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartDetail = await addToCartUseCase(event.accountId, event.productId, event.quantity);
      emit(CartItemAdded(cartDetail));
      _accountId ??= event.accountId;
      final (_, cartDetails) = await getCartUseCase(_accountId!);
      emit(CartLoaded(cartItems: cartDetails));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      print('Removing cart detail with ID: ${event.cartDetailId}');
      await removeFromCartUseCase(event.cartDetailId);
      if (_accountId != null) {
        print('Fetching updated cart for account ID: $_accountId');
        final (_, cartDetails) = await getCartUseCase(_accountId!);
        print('Updated cart details: $cartDetails');
        emit(CartLoaded(cartItems: cartDetails));
        emit(CartItemRemoved(event.cartDetailId));
      } else {
        throw Exception('Không tìm thấy accountId. Vui lòng tải giỏ hàng trước.');
      }
    } catch (e) {
      print('Error removing cart detail: $e');
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final cartDetail = await updateCartQuantityUseCase(event.cartId, event.productId, event.newQuantity);
      emit(CartItemUpdated(cartDetail));
      if (_accountId != null) {
        final (_, cartDetails) = await getCartUseCase(_accountId!);
        emit(CartLoaded(cartItems: cartDetails));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      if (_accountId != null) {
        final (cart, cartDetails) = await getCartUseCase(_accountId!);
        for (var detail in cartDetails) {
          await removeFromCartUseCase(detail.cartDetailId);
        }
        emit(const CartLoaded(cartItems: [])); // Sau khi xóa, giỏ hàng sẽ rỗng
      } else {
        emit(const CartLoaded(cartItems: []));
      }
    } catch (e) {
      emit(CartError('Failed to clear cart: $e'));
    }
  }
}