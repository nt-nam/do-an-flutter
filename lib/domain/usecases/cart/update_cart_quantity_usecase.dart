import 'package:do_an_flutter/domain/entities/cart_detail.dart';
import 'package:do_an_flutter/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository cartRepository;

  UpdateCartQuantityUseCase(this.cartRepository);

  Future<CartDetail> call(int cartId, int productId, int newQuantity) async {
    try {
      // Lấy danh sách chi tiết giỏ hàng dựa trên cartId
      final cartDetails = await cartRepository.getCartDetails(cartId);

      // Tìm chi tiết giỏ hàng dựa trên productId
      final cartDetail = cartDetails.firstWhere(
            (detail) => detail.productId == productId,
        orElse: () => throw Exception('Cart detail not found for product ID: $productId in cart ID: $cartId'),
      );

      // Cập nhật số lượng
      final updatedCartDetail = CartDetail(
        cartDetailId: cartDetail.cartDetailId,
        cartId: cartDetail.cartId,
        productId: cartDetail.productId,
        quantity: newQuantity,
        price: cartDetail.price,
        productName: cartDetail.productName,
        productPrice: cartDetail.productPrice,
        productImage: cartDetail.productImage,
      );

      // Gọi repository để cập nhật
      return await cartRepository.updateCartDetail(updatedCartDetail);
    } catch (e) {
      throw Exception('Failed to update cart quantity: $e');
    }
  }
}