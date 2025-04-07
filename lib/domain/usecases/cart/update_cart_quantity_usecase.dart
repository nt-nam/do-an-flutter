

import '../../entities/cart_detail.dart';
import '../../repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository cartRepository;

  UpdateCartQuantityUseCase(this.cartRepository);

  Future<CartDetail> call(int cartId, int productId, int newQuantity) async {
    // Lấy danh sách chi tiết giỏ hàng để tìm thông tin sản phẩm
    final cartDetails = await cartRepository.getCartDetails(cartId);
    final cartDetail = cartDetails.firstWhere(
          (detail) => detail.productId == productId,
      orElse: () => throw Exception('Không tìm thấy sản phẩm trong giỏ hàng'),
    );

    // Tạo CartDetail mới với số lượng cập nhật
    final updatedCartDetail = CartDetail(
      cartDetailId: cartDetail.cartDetailId,
      cartId: cartId,
      accountId: cartDetail.accountId,
      productId: productId,
      quantity: newQuantity, // Số lượng mới (tuyệt đối)
      createdDate: cartDetail.createdDate,
      productName: cartDetail.productName,
      productPrice: cartDetail.productPrice,
      productImage: cartDetail.productImage,
    );

    // Cập nhật số lượng
    return await cartRepository.updateCartDetail(updatedCartDetail);
  }
}