import '../../entities/product.dart';
import '../../repositories/product_repository.dart';
import '../../../data/models/product_model.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Product> call({
    required String name,
    required int categoryId,
    required double price,
    required int stock,
  }) async {
    try {
      final productModel = ProductModel(
        maSP: 0, // API sẽ sinh
        tenSP: name,
        moTa: null,
        gia: price,
        maLoai: categoryId,
        hinhAnh: null,
        trangThai: stock > 0 ? 'Còn hàng' : 'Hết hàng',
        soLuongTon: stock,
      );
      final result = await repository.createProduct(productModel);
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
      throw Exception('Failed to add product: $e');
    }
  }
}