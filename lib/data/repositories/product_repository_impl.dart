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
    final data = await apiService.get('sanpham', token: token);
    return (data as List).map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final token = await authService.getToken();
    final data = await apiService.get('sanpham?id=$id', token: token);
    return ProductModel.fromJson(data);
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    final token = await authService.getToken();
    final data = await apiService.post('sanpham', product.toJson(), token: token);
    return ProductModel.fromJson(data);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final token = await authService.getToken();
    final data = await apiService.put('sanpham/${product.maSP}', product.toJson(), token: token);
    return ProductModel.fromJson(data);
  }

  @override
  Future<void> deleteProduct(int id) async {
    final token = await authService.getToken();
    await apiService.delete('sanpham/$id', token: token);
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final token = await authService.getToken();
    final data = await apiService.get('sanpham?MaLoai=$categoryId', token: token);
    return (data as List).map((json) => ProductModel.fromJson(json)).toList();
  }
}