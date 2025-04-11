
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

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
        description: modelProduct.moTa, // Thêm description
        categoryId: modelProduct.maLoai, // Thêm categoryId
        imageUrl: modelProduct.hinhAnh, // Thêm imageUrl
      );
    } catch (e) {
      throw Exception('Failed to get product by id: $e');
    }
  }
}