import 'dart:io';

import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;
  final AuthService authService;

  ProductRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<ProductModel>> getProducts() async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch products: ${response['message']}');
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?id=$id', token: token);
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']);
    }
    throw Exception('Failed to fetch product: ${response['message']}');
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final token = await authService.getToken();
    final data = product.toJson();
    final response = product.hinhAnh is File
        ? await apiService.postWithImage('products.php', data, token: token)
        : await apiService.post('products.php', data, token: token);
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']);
    }
    throw Exception('Failed to create product: ${response['message']}');
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final token = await authService.getToken();
    final response = await apiService.put(
      'products.php?id=${product.maSP}',
      product.toJson(),
      token: token,
    );
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']);
    }
    throw Exception('Failed to update product: ${response['message']}');
  }

  @override
  Future<void> deleteProduct(int id) async {
    final token = await authService.getToken();
    final response = await apiService.delete('products.php?id=$id', token: token);
    if (response['status'] != 'success') {
      throw Exception('Failed to delete product: ${response['message']}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?MaLoai=$categoryId', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch products by category: ${response['message']}');
  }

  @override
  Future<String> uploadImage(File imageFile, String fileName) async {
    final token = await authService.getToken();
    final response = await apiService.uploadFile('products.php', imageFile, fileName, token: token);
    if (response['status'] == 'success') {
      return response['imageUrl'];
    }
    throw Exception('Failed to upload image: ${response['message']}');
  }
  Future<List<ProductModel>> getFeaturedProducts(int limit) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?featured=1&limit=$limit', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch featured products: ${response['message']}');
  }

  Future<List<ProductModel>> getNewProducts(int limit) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?new=1&limit=$limit', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch new products: ${response['message']}');
  }
}