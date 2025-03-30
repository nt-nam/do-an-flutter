import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../data/models/product_model.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
    int page = 1,
    int limit = 10,
    int? categoryId,
    String? searchQuery,
    bool onlyAvailable = false,
  }) async {
    try {
      final productModels = categoryId != null
          ? await repository.getProductsByCategory(categoryId)
          : await repository.getProducts();
      var filteredProducts = productModels
          .where((model) => !onlyAvailable || model.trangThai == 'Còn hàng')
          .map(_mapToEntity)
          .toList();

      // Lọc theo searchQuery nếu có
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
            product.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      return filteredProducts;
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  Product _mapToEntity(ProductModel model) {
    return Product(
      id: model.maSP,
      name: model.tenSP,
      description: model.moTa,
      price: model.gia,
      categoryId: model.maLoai,
      imageUrl: model.hinhAnh,
      status: model.trangThai == 'Còn hàng' ? ProductStatus.inStock : ProductStatus.outOfStock,
      stock: model.soLuongTon,
    );
  }
}