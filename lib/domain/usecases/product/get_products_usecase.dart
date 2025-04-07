import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 10,
    bool featured = false,
    bool newProducts = false,
    bool onlyAvailable = false,
  }) async {
    try {
      List<Product> products;
      if (featured) {
        products = await repository.getFeaturedProducts(limit);
      } else if (newProducts) {
        products = await repository.getNewProducts(limit);
      } else if (categoryId != null) {
        products = await repository.getProductsByCategory(categoryId);
      } else {
        products = await repository.getProducts();
      }

      // Filter by searchQuery and onlyAvailable if needed
      if (searchQuery != null && searchQuery.isNotEmpty) {
        products = products
            .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
      if (onlyAvailable) {
        products = products.where((p) => p.status == ProductStatus.inStock).toList();
      }

      return products;
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }
}