import '../models/cart_model.dart';
import '../models/cart_detail_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiService apiService;
  final AuthService authService;

  CartRepositoryImpl(this.apiService, this.authService);

  @override
  Future<CartModel> getCart(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang?MaTK=$accountId', token: token);
    return CartModel.fromJson(data); // Giả định API trả về một giỏ hàng duy nhất
  }

  @override
  Future<List<CartDetailModel>> getCartDetails(int cartId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang/chitiet?MaGH=$cartId', token: token);
    return (data as List).map((json) => CartDetailModel.fromJson(json)).toList();
  }

  @override
  Future<CartDetailModel> addToCart(CartDetailModel cartDetail) async {
    final token = await authService.getToken();
    final data = await apiService.post('giohang/chitiet', cartDetail.toJson(), token: token);
    return CartDetailModel.fromJson(data);
  }

  @override
  Future<CartDetailModel> updateCartDetail(CartDetailModel cartDetail) async {
    final token = await authService.getToken();
    final data = await apiService.put(
      'giohang/chitiet/${cartDetail.maGH}/${cartDetail.maSP}',
      cartDetail.toJson(),
      token: token,
    );
    return CartDetailModel.fromJson(data);
  }

  @override
  Future<void> removeFromCart(int cartDetailId) async {
    final token = await authService.getToken();
    await apiService.delete('giohang/chitiet/$cartDetailId', token: token);
  }
}