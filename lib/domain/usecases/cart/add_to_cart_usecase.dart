import '../../../domain/entities/cart.dart';
import '../../../domain/entities/cart_detail.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repositories/cart_repository.dart';
import '../../../domain/repositories/product_repository.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase(this.cartRepository, this.productRepository);

  Future<CartDetail> call(int accountId, int productId, int quantity) async {
    try {
      if (quantity <= 0) throw Exception('Quantity must be positive');
      final product = await productRepository.getProductById(productId);
      if (product.status == 'Hết hàng') throw Exception('Product out of stock');

      final cart = await cartRepository.getCart(accountId);
      final cartId = cart.cartId;
      if (cartId == null) {
        throw Exception('Cart not found for account ID: $accountId');
      }

      // Lấy thông tin sản phẩm
      // final product = await productRepository.getProductById(productId);
      if (product == null) {
        throw Exception('Product not found for ID: $productId');
      }

      // Tạo chi tiết giỏ hàng
      final cartDetail = CartDetail(
        cartDetailId: 0,
        cartId: cartId,
        accountId: accountId,
        productId: productId,
        quantity: quantity, // Số lượng ban đầu (thường là 1)
        createdDate: DateTime.now().toIso8601String(),
        productName: product.name ?? 'Unknown Product',
        productPrice: product.price ?? 0.0,
        productImage: product.imageUrl,
      );

      // Thêm vào giỏ hàng
      final addedCartDetail = await cartRepository.addToCart(cartDetail);
      return addedCartDetail;
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }
}