import 'package:do_an_flutter/data/models/cart_model.dart';
import 'package:do_an_flutter/data/models/cart_detail_model.dart';
import 'package:do_an_flutter/domain/entities/cart.dart';
import 'package:do_an_flutter/domain/entities/cart_detail.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'package:do_an_flutter/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiService apiService;
  final AuthService authService;

  CartRepositoryImpl(this.apiService, this.authService);

  @override
  Future<Cart> getCart(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang?MaTK=$accountId', token: token);
    return CartModel.fromJson(data).toEntity(); // Chuyển đổi sang entity
  }

  @override
  Future<List<CartDetail>> getCartDetails(int cartId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang/chitiet?MaGH=$cartId', token: token);
    return (data as List)
        .map((json) => CartDetailModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<CartDetail> addToCart(CartDetail cartDetail) async {
    final token = await authService.getToken();
    final data = await apiService.post(
      'giohang/chitiet',
      CartDetailModel.fromEntity(cartDetail).toJson(),
      token: token,
    );
    return CartDetailModel.fromJson(data).toEntity();
  }

  @override
  Future<CartDetail> updateCartDetail(CartDetail cartDetail) async {
    final token = await authService.getToken();
    final data = await apiService.put(
      'giohang/chitiet/${cartDetail.cartId}/${cartDetail.productId}',
      CartDetailModel.fromEntity(cartDetail).toJson(),
      token: token,
    );
    return CartDetailModel.fromJson(data).toEntity();
  }

  @override
  Future<void> removeFromCart(int cartDetailId) async {
    final token = await authService.getToken();
    await apiService.delete('giohang/chitiet/$cartDetailId', token: token);
  }

  @override
  Future<void> clearCart(int accountId) async {
    final token = await authService.getToken();
    final response = await apiService.delete(
      'giohang?MaTK=$accountId',
      token: token,
    );

    if (response['status'] != 'success') {
      throw Exception('Failed to clear cart: ${response['message']}');
    }
  }
}