import '../entities/cart.dart';
import '../repositories/cart_repository.dart';
import '../repositories/product_repository.dart';
import '../../data/models/cart_model.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase(this.cartRepository, this.productRepository);

  Future<Cart> call(int accountId, int productId, int quantity) async {
    try {
      if (quantity <= 0) throw Exception('Quantity must be positive');
      // Kiểm tra sản phẩm (giả định cần thêm logic kiểm tra số lượng tồn kho)
      final product = await productRepository.getProductById(productId);
      if (product.trangThai == 'Hết hàng') throw Exception('Product out of stock');

      final cartModel = CartModel(
        maGH: 0,
        maTK: accountId,
        maSP: productId,
        soLuong: quantity,
        ngayThem: DateTime.now(),
      );
      final result = await cartRepository.addToCart(cartModel);
      return _mapToEntity(result);
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
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