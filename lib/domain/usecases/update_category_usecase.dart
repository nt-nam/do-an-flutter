import '../entities/category.dart';
import '../repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Category> call(int categoryId, String name) async {
    try {
      if (name.isEmpty) throw Exception('Category name cannot be empty');
      final categoryModel = CategoryModel(maLoai: categoryId, tenLoai: name);
      final result = await repository.updateCategory(categoryModel);
      return Category(id: result.maLoai, name: result.tenLoai);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }
}