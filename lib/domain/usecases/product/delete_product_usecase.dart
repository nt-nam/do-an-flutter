import '../../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int id) async {
    try {
      await repository.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}