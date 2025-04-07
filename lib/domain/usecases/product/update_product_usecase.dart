import 'dart:io';

import '../../../data/models/product_model.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Product> call({
    required int productId,
    required String name,
    required int categoryId,
    required double price,
    required int stock,
    File? imageFile,
    String? description,
  }) async {
    try {
      final productModel = ProductModel(
        id: productId,
        name: name,
        description: description,
        price: price,
        categoryId: categoryId,
        imageUrl: null, // Repository will set this after uploading
        status: stock > 0 ? 'Còn hàng' : 'Hết hàng',
        stock: stock,
      );
      final result = await repository.updateProduct(productModel, imageFile: imageFile);
      return Product(
        id: result.id,
        name: result.name,
        description: result.description,
        price: result.price,
        categoryId: result.categoryId,
        imageUrl: result.imageUrl,
        status: result.status == 'Còn hàng' ? ProductStatus.inStock : ProductStatus.outOfStock,
        stock: result.stock,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }
}