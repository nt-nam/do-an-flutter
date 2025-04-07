import 'dart:io';
import '../../data/models/product_model.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Product> createProduct(ProductModel product, {File? imageFile});
  Future<Product> updateProduct(ProductModel product, {File? imageFile});
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByCategory(int categoryId);
  Future<List<Product>> getFeaturedProducts(int limit);
  Future<List<Product>> getNewProducts(int limit);
  Future<void> deleteProduct(int id);
  Future<Product> getProductById(int id);
}