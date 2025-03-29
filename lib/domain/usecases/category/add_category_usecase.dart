import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../../data/models/category_model.dart';

class AddCategoryUseCase {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  Future<Category> call(String name) async {
    try {
      // Ánh xạ từ name sang CategoryModel
      final categoryModel = CategoryModel(
        maLoai: 0, // maLoai sẽ được tạo tự động bởi API, nên đặt tạm là 0
        tenLoai: name,
      );
      final createdModel = await repository.createCategory(categoryModel);
      return _mapToEntity(createdModel);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Category _mapToEntity(CategoryModel model) {
    return Category(id: model.maLoai, name: model.tenLoai);
  }
}