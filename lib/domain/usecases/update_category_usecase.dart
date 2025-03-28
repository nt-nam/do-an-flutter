import '../entities/category.dart';
import '../repositories/category_repository.dart';
import '../../data/models/category_model.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<Category> call(int categoryId, String name) async {
    try {
      // Ánh xạ từ categoryId và name sang CategoryModel
      final categoryModel = CategoryModel(
        maLoai: categoryId,
        tenLoai: name,
      );
      final updatedModel = await repository.updateCategory(categoryModel);
      return _mapToEntity(updatedModel);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Category _mapToEntity(CategoryModel model) {
    return Category(id: model.maLoai, name: model.tenLoai);
  }
}