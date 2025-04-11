import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../data/models/product_model.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Product> call({
    required int productId,
    required String name,
    required int categoryId,
    required double price,
    required int stock,
    String? imageUrl, // Thêm tham số imageUrl
    String? description, // Thêm tham số description
  }) async {
    try {
      final productModel = ProductModel(
        maSP: productId,
        tenSP: name,
        moTa: description,
        gia: price,
        maLoai: categoryId,
        hinhAnh: imageUrl, // Sử dụng imageUrl
        trangThai: stock > 0 ? 'Còn hàng' : 'Hết hàng',
        soLuongTon: stock,
      );
      final result = await repository.updateProduct(productModel);
      return Product(
        id: result.maSP,
        name: result.tenSP,
        description: result.moTa,
        price: result.gia,
        categoryId: result.maLoai,
        imageUrl: result.hinhAnh,
        status: result.trangThai == 'Còn hàng' ? ProductStatus.inStock : ProductStatus.outOfStock,
        stock: result.soLuongTon,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}