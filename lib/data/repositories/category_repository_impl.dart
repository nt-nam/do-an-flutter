import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final String baseUrl = "http://localhost/gas_api";

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/loaisanpham'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Không thể lấy danh sách loại sản phẩm');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/loaisanpham?id=$id'));
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Không tìm thấy loại sản phẩm');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loaisanpham'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data['category']);
    } else {
      throw Exception('Không thể tạo loại sản phẩm');
    }
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    final response = await http.put(
      Uri.parse('$baseUrl/loaisanpham?id=${category.maLoai}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data['category']);
    } else {
      throw Exception('Không thể cập nhật loại sản phẩm');
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/loaisanpham?id=$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Không thể xóa loại sản phẩm');
    }
  }
}