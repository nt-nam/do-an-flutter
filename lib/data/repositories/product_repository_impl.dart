import 'dart:io';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;
  final AuthService authService;

  ProductRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<Product>> getProducts() async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json).toEntity()).toList();
    }
    throw Exception('Failed to fetch products: ${response['message']}');
  }

  @override
  Future<Product> getProductById(int id) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?id=$id', token: token);
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']).toEntity();
    }
    throw Exception('Failed to fetch product: ${response['message']}');
  }

  @override
  Future<Product> createProduct(ProductModel product, {File? imageFile}) async {
    final token = await authService.getToken();
    Map<String, dynamic> data = product.toJson();

    // Handle image upload if provided
    if (imageFile != null) {
      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageUrl = await uploadImage(imageFile, fileName);
      data['HinhAnh'] = imageUrl; // Update the imageUrl field with the uploaded URL
    }

    final response = await apiService.post('products.php', data, token: token);
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']).toEntity();
    }
    throw Exception('Failed to create product: ${response['message']}');
  }

  @override
  Future<Product> updateProduct(ProductModel product, {File? imageFile}) async {
    final token = await authService.getToken();
    Map<String, dynamic> data = product.toJson();

    // Handle image upload if provided
    if (imageFile != null) {
      final fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imageUrl = await uploadImage(imageFile, fileName);
      data['HinhAnh'] = imageUrl; // Update the imageUrl field with the uploaded URL
    }

    final response = await apiService.put(
      'products.php?id=${product.id}', // Changed from maSP to id
      data,
      token: token,
    );
    if (response['status'] == 'success') {
      return ProductModel.fromJson(response['data']).toEntity();
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
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?MaLoai=$categoryId', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json).toEntity()).toList();
    }
    throw Exception('Failed to fetch products by category: ${response['message']}');
  }

  @override
  Future<List<Product>> getFeaturedProducts(int limit) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?featured=1&limit=$limit', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json).toEntity()).toList();
    }
    throw Exception('Failed to fetch featured products: ${response['message']}');
  }

  @override
  Future<List<Product>> getNewProducts(int limit) async {
    final token = await authService.getToken();
    final response = await apiService.get('products.php?new=1&limit=$limit', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => ProductModel.fromJson(json).toEntity()).toList();
    }
    throw Exception('Failed to fetch new products: ${response['message']}');
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
}