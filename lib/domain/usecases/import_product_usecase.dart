import '../entities/import.dart';
import '../repositories/import_repository.dart';
import '../repositories/product_repository.dart';
import '../../data/models/import_model.dart';

class ImportProductUseCase {
  final ImportRepository importRepository;
  final ProductRepository productRepository;

  ImportProductUseCase(this.importRepository, this.productRepository);

  Future<Import> call(int productId, int warehouseId, int quantity) async {
    try {
      if (quantity <= 0) throw Exception('Quantity must be positive');
      final importModel = ImportModel(
        maNhap: 0,
        maSP: productId,
        maKho: warehouseId,
        soLuong: quantity,
        ngayNhap: DateTime.now(),
      );
      final result = await importRepository.createImport(importModel);
      return _mapToEntity(result);
    } catch (e) {
      throw Exception('Failed to import product: $e');
    }
  }

  Import _mapToEntity(ImportModel model) {
    return Import(
      id: model.maNhap,
      productId: model.maSP,
      warehouseId: model.maKho,
      quantity: model.soLuong,
      importDate: model.ngayNhap,
    );
  }
}