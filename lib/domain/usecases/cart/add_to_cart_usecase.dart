import 'package:do_an_flutter/domain/entities/cart.dart';
import 'package:do_an_flutter/domain/entities/cart_detail.dart';
import 'package:do_an_flutter/domain/entities/product.dart';
import 'package:do_an_flutter/domain/repositories/cart_repository.dart';
import 'package:do_an_flutter/domain/repositories/product_repository.dart';

class AddToCartUseCase {
  final CartRepository cartRepository;
  final ProductRepository productRepository;

  AddToCartUseCase(this.cartRepository, this.productRepository);

  Future<CartDetail> call(int accountId, int productId, int quantity) async {
    try {
      // Lấy giỏ hàng của tài khoản
      final cart = await cartRepository.getCart(accountId);
      final cartId = cart.cartId;
      if (cartId == null) {
        throw Exception('Cart not found for account ID: $accountId');
      }

      // Lấy thông tin sản phẩm
      final product = await productRepository.getProductById(productId);
      if (product == null) {
        throw Exception('Product not found for ID: $productId');
      }

      // Tạo chi tiết giỏ hàng
      final cartDetail = CartDetail(
        cartDetailId: 0, // ID sẽ được tạo bởi API
        cartId: cartId,
        productId: productId,
        quantity: quantity,
        price: product.gia ?? 0.0,
        productName: product.tenSP ?? 'Unknown Product',
        productPrice: product.gia ?? 0.0,
        productImage: product.hinhAnh,
      );

      // Thêm vào giỏ hàng
      final addedCartDetail = await cartRepository.addToCart(cartDetail);
      return addedCartDetail;
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }
}