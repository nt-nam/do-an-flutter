import '../models/category_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiService apiService;
  final AuthService authService;

  CategoryRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final data = await apiService.get('loaisanpham');
    print('Dữ liệu từ API /loaisanpham/ : $data');
    return (data as List).map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    final data = await apiService.get('loaisanpham/$id');
    return CategoryModel.fromJson(data);
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    final token = await authService.getToken();
    final data = await apiService.post('loaisanpham', category.toJson(), token: token);
    return CategoryModel.fromJson(data);
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    final token = await authService.getToken();
    final data = await apiService.put('loaisanpham/${category.maLoai}', category.toJson(), token: token);
    return CategoryModel.fromJson(data);
  }

  @override
  Future<void> deleteCategory(int id) async {
    final token = await authService.getToken();
    await apiService.delete('loaisanpham/$id', token: token);
  }
}