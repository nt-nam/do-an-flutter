import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetProductByIdUsecase {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  Future<Product> call(int id) async {
    try {
      final modelProduct = await repository.getProductById(id);
      return Product(
        id: modelProduct.id,
        name: modelProduct.name,
        price: modelProduct.price,
        status: modelProduct.status == 'Còn hàng'
            ? ProductStatus.inStock
            : ProductStatus.outOfStock,
        stock: modelProduct.stock,
        description: modelProduct.description,
        categoryId: modelProduct.categoryId,
        imageUrl: modelProduct.imageUrl,
      );
    } catch (e) {
      throw Exception('Failed to get product by id: $e');
    }
  }
}