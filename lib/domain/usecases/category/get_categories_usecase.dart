import '../../entities/category.dart';
import '../../repositories/category_repository.dart';
import '../../../data/models/category_model.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call({int page = 1, int limit = 10, String? searchQuery}) async {
    try {
      final categoryModels = await repository.getCategories(); // Cần cập nhật repository nếu thêm phân trang
      return categoryModels.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  Category _mapToEntity(CategoryModel model) {
    final id = int.tryParse(model.maLoai.toString()) ?? 0;
    return Category(id: id, name: model.tenLoai);
  }
}