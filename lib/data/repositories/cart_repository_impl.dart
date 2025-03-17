import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiService apiService;
  final AuthService authService;

  CartRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<CartModel>> getCartItems(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang?MaTK=$accountId', token: token);
    return (data as List).map((json) => CartModel.fromJson(json)).toList();
  }

  @override
  Future<CartModel> addToCart(CartModel cartItem) async {
    final token = await authService.getToken();
    final data = await apiService.post('giohang', cartItem.toJson(), token: token);
    return CartModel.fromJson(data);
  }

  @override
  Future<CartModel> updateCartItem(CartModel cartItem) async {
    final token = await authService.getToken();
    final data = await apiService.put('giohang/${cartItem.maGH}', cartItem.toJson(), token: token);
    return CartModel.fromJson(data);
  }

  @override
  Future<void> removeFromCart(int cartId) async {
    final token = await authService.getToken();
    await apiService.delete('giohang/$cartId', token: token);
  }
}