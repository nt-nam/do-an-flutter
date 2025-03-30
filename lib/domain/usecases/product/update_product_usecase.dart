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
  }) async {
    try {
      final productModel = ProductModel(
        maSP: productId,
        tenSP: name,
        moTa: null, // Giữ nguyên hoặc thêm tham số nếu cần
        gia: price,
        maLoai: categoryId,
        hinhAnh: null, // Giữ nguyên hoặc thêm tham số nếu cần
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