import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../data/models/product_model.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call({
    int page = 1,
    int limit = 10,
    List<int>? categoryIds, // Thay đổi từ int? categoryId thành List<int>?
    String? searchQuery,
    bool onlyAvailable = false,
  }) async {
    try {
      // Lấy danh sách sản phẩm từ repository
      final productModels = await repository.getProducts();

      // Lọc sản phẩm theo danh sách categoryIds (nếu có)
      var filteredProducts = productModels
          .where((model) =>
      categoryIds == null || categoryIds.contains(model.maLoai))
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
      status: model.trangThai == 'Còn hàng'
          ? ProductStatus.inStock
          : ProductStatus.outOfStock,
      stock: model.soLuongTon,
    );
  }
}