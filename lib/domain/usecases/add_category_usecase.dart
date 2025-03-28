import '../entities/category.dart';
import '../repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  Future<Category> call(String name) async {
    try {
      if (name.isEmpty) throw Exception('Category name cannot be empty');
      final categoryModel = CategoryModel(maLoai: 0, tenLoai: name);
      final result = await repository.createCategory(categoryModel);
      return Category(id: result.maLoai, name: result.tenLoai);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }
}