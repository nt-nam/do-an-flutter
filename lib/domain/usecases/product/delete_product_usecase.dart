import '../../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int Id) async {
    try {
      await repository.deleteProduct(Id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}