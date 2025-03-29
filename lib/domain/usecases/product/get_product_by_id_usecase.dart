import 'package:do_an_flutter/domain/entities/product.dart';
import 'package:do_an_flutter/domain/repositories/product_repository.dart';

class GetProductByIdUsecase {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  Future<Product> call(int id) async {
    try {
      final modelProduct = await repository.getProductById(id);
      return Product(
        id: modelProduct.maSP,
        name: modelProduct.tenSP,
        price: modelProduct.gia,
        status: modelProduct.trangThai == 'Còn hàng'
            ? ProductStatus.inStock
            : ProductStatus.outOfStock,
        stock: modelProduct.soLuongTon,
      );
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }
}
