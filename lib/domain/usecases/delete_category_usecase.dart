import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(int categoryId) async {
    try {
      await repository.deleteCategory(categoryId);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}