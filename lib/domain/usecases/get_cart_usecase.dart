import '../entities/cart.dart';
import '../repositories/cart_repository.dart';
import '../../data/models/cart_model.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<List<Cart>> call(int accountId) async {
    try {
      final cartModels = await repository.getCartItems(accountId);
      return cartModels.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }

  Cart _mapToEntity(CartModel model) {
    return Cart(
      id: model.maGH,
      accountId: model.maTK,
      productId: model.maSP,
      quantity: model.soLuong,
      addedDate: model.ngayThem,
    );
  }
}