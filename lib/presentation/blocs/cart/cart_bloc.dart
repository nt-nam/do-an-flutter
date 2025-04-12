import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int? _cartId; // Lưu trữ cartId
  List<CartDetail> _currentCartItems = [];

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
      _accountId = event.accountId;
      _cartId = cart.cartId; // Lưu cartId
      _currentCartItems = cartDetails;
      emit(CartLoaded(cartItems: cartDetails));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      // Kiểm tra cartId từ shared_preferences
      final prefs = await SharedPreferences.getInstance();
      String? cartId = prefs.getString('cartId');
      if (cartId == null) {
        // Nếu không có cartId, gọi FetchCartEvent để lấy
        await _onFetchCart(FetchCartEvent(event.accountId), emit);
        cartId = _cartId?.toString();
        if (cartId == null) {
          throw Exception('Không tìm thấy giỏ hàng cho tài khoản ID: ${event.accountId}');
        }
      }

      final cartDetail = await addToCartUseCase(event.accountId, event.productId, event.quantity);
      emit(CartItemAdded(cartDetail));
      _accountId ??= event.accountId;
      final (_, cartDetails) = await getCartUseCase(_accountId!);
      _currentCartItems = cartDetails;
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
        _currentCartItems = cartDetails;
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
    try {
      final updatedCartDetail = await updateCartQuantityUseCase(event.cartId, event.productId, event.newQuantity);
      final updatedCartItems = [..._currentCartItems];
      final index = updatedCartItems.indexWhere((item) => item.cartId == event.cartId && item.productId == event.productId);
      if (index != -1) {
        updatedCartItems[index] = updatedCartDetail;
      }
      _currentCartItems = updatedCartItems;
      emit(CartItemUpdated(updatedCartDetail));
      emit(CartLoaded(cartItems: updatedCartItems));
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
        _currentCartItems = [];
        emit(const CartLoaded(cartItems: []));
      } else {
        _currentCartItems = [];
        emit(const CartLoaded(cartItems: []));
      }
    } catch (e) {
      emit(CartError('Failed to clear cart: $e'));
    }
  }
}