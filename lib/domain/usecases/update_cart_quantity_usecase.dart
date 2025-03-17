import '../entities/cart.dart';
import '../repositories/cart_repository.dart';
import '../../data/models/cart_model.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<Cart> call(int cartId, int newQuantity) async {
    try {
      if (newQuantity <= 0) throw Exception('Quantity must be positive');
      final cartModel = CartModel(
        maGH: cartId,
        maTK: null, // Không cần gửi lại, API sẽ giữ nguyên
        maSP: null, // Không cần gửi lại
        soLuong: newQuantity,
        ngayThem: DateTime.now(), // Không cần cập nhật, API sẽ giữ nguyên
      );
      final updatedCart = await repository.updateCartItem(cartModel);
      return Cart(
        id: updatedCart.maGH,
        accountId: updatedCart.maTK,
        productId: updatedCart.maSP,
        quantity: updatedCart.soLuong,
        addedDate: updatedCart.ngayThem,
      );
    } catch (e) {
      throw Exception('Failed to update cart quantity: $e');
    }
  }
}