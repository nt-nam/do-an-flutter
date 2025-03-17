import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../data/models/product_model.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({int page = 1, int limit = 10, int? categoryId, String? searchQuery}) async {
    try {
      final productModels = categoryId != null
          ? await repository.getProductsByCategory(categoryId)
          : await repository.getProducts();
      return productModels.map(_mapToEntity).toList();
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
      status: model.trangThai,
    );
  }
}