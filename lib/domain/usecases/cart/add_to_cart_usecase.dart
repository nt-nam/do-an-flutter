import '../../entities/cart_detail.dart';
import '../../repositories/cart_repository.dart';
import '../../repositories/product_repository.dart';
import '../../../data/models/cart_detail_model.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase(this.cartRepository, this.productRepository);

  Future<CartDetail> call(int accountId, int productId, int quantity) async {
    try {
      if (quantity <= 0) throw Exception('Quantity must be positive');
      final product = await productRepository.getProductById(productId);
      if (product.trangThai == 'Hết hàng') throw Exception('Product out of stock');

      final cart = await cartRepository.getCart(accountId);
      final cartDetailModel = CartDetailModel(
        maGH: cart.maGH,
        maSP: productId,
        soLuong: quantity,
      );
      final result = await cartRepository.addToCart(cartDetailModel);
      return CartDetail(
        cartId: result.maGH,
        productId: result.maSP,
        quantity: result.soLuong,
        productName: result.tenSP,
        price: result.gia,
        image: result.hinhAnh,
      );
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }
}