import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_detail.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_detail_model.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class CartRepositoryImpl implements CartRepository {
  final ApiService apiService;
  final AuthService authService;

  CartRepositoryImpl(this.apiService, this.authService);

  @override
  Future<Cart> getCart(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang?MaTK=$accountId', token: token);
    print('Raw JSON response: $data');
    if (data['status'] != 'success') {
      throw Exception('Failed to get cart: ${data['message']}');
    }
    return CartModel.fromJson(data['data']).toEntity();
  }

  @override
  Future<List<CartDetail>> getCartDetails(int cartId) async {
    final token = await authService.getToken();
    final data = await apiService.get('giohang/chitiet?MaGH=$cartId', token: token);
    print('Raw JSON response from getCartDetails: $data');

    // Kiểm tra nếu data là một List trực tiếp (không có status và data)
    if (data is List) {
      final cartDetails = (data as List)
          .map((json) => CartDetailModel.fromJson(json as Map<String, dynamic>).toEntity())
          .toList();
      print('Parsed cart details: $cartDetails');
      return cartDetails;
    }

    // Trường hợp API trả về cấu trúc {status: ..., data: ...} (nếu có trong tương lai)
    if (data['status'] != 'success') {
      throw Exception('Failed to get cart details: ${data['message']}');
    }
    final cartDetails = (data['data'] as List)
        .map((json) => CartDetailModel.fromJson(json as Map<String, dynamic>).toEntity())
        .toList();
    print('Parsed cart details: $cartDetails');
    return cartDetails;
  }

  @override
  Future<CartDetail> addToCart(CartDetail cartDetail) async {
    final token = await authService.getToken();

    // Lấy giỏ hàng của tài khoản để lấy cartId (MaGH)
    final cart = await getCart(cartDetail.accountId);
    final cartId = cart.cartId;
    if (cartId == null) {
      throw Exception('Không tìm thấy giỏ hàng cho tài khoản ID: ${cartDetail.accountId}');
    }

    // Lưu cartId vào shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartId', cartId.toString());

    // Lấy danh sách chi tiết giỏ hàng để kiểm tra số lượng hiện tại
    final cartDetails = await getCartDetails(cartId);
    final existingCartDetail = cartDetails.firstWhere(
          (detail) => detail.productId == cartDetail.productId,
      orElse: () => CartDetail(
        cartDetailId: 0,
        cartId: cartId,
        accountId: cartDetail.accountId,
        productId: cartDetail.productId,
        quantity: 0,
        createdDate: cartDetail.createdDate,
        productName: cartDetail.productName,
        productPrice: cartDetail.productPrice,
        productImage: cartDetail.productImage,
      ),
    );

    // Tính số lượng mới (cộng dồn)
    final newQuantity = existingCartDetail.quantity + cartDetail.quantity;

    // Gửi yêu cầu POST với số lượng mới
    final data = await apiService.post(
      'giohang/chitiet',
      {
        'MaTK': cartDetail.accountId,
        'MaSP': cartDetail.productId,
        'SoLuong': newQuantity,
      },
      token: token,
    );

    // Kiểm tra nếu data là một List trực tiếp (không có status và data)
    if (data is List) {
      final updatedCartDetails = (data as List)
          .map((json) => CartDetailModel.fromJson(json as Map<String, dynamic>))
          .toList();

      final addedCartDetail = updatedCartDetails.firstWhere(
            (detail) => detail.maSP == cartDetail.productId,
        orElse: () => throw Exception('Không tìm thấy chi tiết giỏ hàng vừa thêm'),
      );

      return addedCartDetail.toEntity();
    }

    // Trường hợp API trả về cấu trúc {status: ..., data: ...} (nếu có trong tương lai)
    if (data['status'] != 'success') {
      throw Exception('Failed to add to cart: ${data['message']}');
    }

    final updatedCartDetails = (data['data'] as List)
        .map((json) => CartDetailModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final addedCartDetail = updatedCartDetails.firstWhere(
          (detail) => detail.maSP == cartDetail.productId,
      orElse: () => throw Exception('Không tìm thấy chi tiết giỏ hàng vừa thêm'),
    );

    return addedCartDetail.toEntity();
  }

  @override
  Future<CartDetail> updateCartDetail(CartDetail cartDetail) async {
    if (cartDetail.accountId == 0) {
      throw Exception('accountId không hợp lệ (0). Vui lòng kiểm tra dữ liệu từ API.');
    }
    if (cartDetail.productId == 0) {
      throw Exception('productId không hợp lệ (0). Vui lòng kiểm tra dữ liệu từ API.');
    }

    final token = await authService.getToken();
    final data = await apiService.post(
      'giohang/chitiet',
      {
        'MaTK': cartDetail.accountId,
        'MaSP': cartDetail.productId,
        'SoLuong': cartDetail.quantity,
      },
      token: token,
    );

    if (data['status'] != 'success') {
      throw Exception('Failed to update cart detail: ${data['message']}');
    }

    final cartDetails = (data['data'] as List)
        .map((json) => CartDetailModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final updatedCartDetail = cartDetails.firstWhere(
          (detail) => detail.maSP == cartDetail.productId,
      orElse: () => throw Exception('Không tìm thấy chi tiết giỏ hàng vừa cập nhật'),
    );

    return updatedCartDetail.toEntity();
  }

  @override
  Future<void> removeFromCart(int cartDetailId) async {
    if (cartDetailId == 0) {
      throw Exception('cartDetailId không hợp lệ (0). Vui lòng kiểm tra dữ liệu từ API.');
    }

    final token = await authService.getToken();
    final response = await apiService.delete('giohang/chitiet?MaCTGH=$cartDetailId', token: token);

    if (response['status'] != 'success') {
      throw Exception('Xóa chi tiết giỏ hàng thất bại: ${response['message']}');
    }
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