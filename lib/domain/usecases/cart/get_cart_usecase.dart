import '../../entities/cart.dart';
import '../../entities/cart_detail.dart';
import '../../repositories/cart_repository.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/cart_detail_model.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<(Cart, List<CartDetail>)> call(int accountId) async {
    try {
      final cartModel = await repository.getCart(accountId);
      final cartDetails = await repository.getCartDetails(cartModel.maGH);
      final cart = Cart(
        id: cartModel.maGH,
        accountId: cartModel.maTK,
        addedDate: cartModel.ngayThem,
        status: cartModel.trangThai,
      );
      final cartDetailList = cartDetails.map((model) => CartDetail(
        cartId: model.maGH,
        productId: model.maSP,
        quantity: model.soLuong,
      )).toList();
      return (cart, cartDetailList);
    } catch (e) {
      throw Exception('Failed to get cart: $e');
    }
  }
}