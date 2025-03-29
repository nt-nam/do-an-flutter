import '../../entities/cart_detail.dart';
import '../../repositories/cart_repository.dart';
import '../../../data/models/cart_detail_model.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<CartDetail> call(int cartId, int productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) throw Exception('Quantity must be positive');
      final cartDetailModel = CartDetailModel(
        maGH: cartId,
        maSP: productId,
        soLuong: newQuantity,
      );
      final updatedCartDetail = await repository.updateCartDetail(cartDetailModel);
      return CartDetail(
        cartId: updatedCartDetail.maGH,
        productId: updatedCartDetail.maSP,
        quantity: updatedCartDetail.soLuong,
      );
    } catch (e) {
      throw Exception('Failed to update cart quantity: $e');
    }
  }
}