import '../entities/warehouse.dart';
import '../repositories/warehouse_repository.dart';
import '../../data/models/warehouse_model.dart';

class GetWarehouseUseCase {
  final WarehouseRepository repository;

  GetWarehouseUseCase(this.repository);

  Future<List<Warehouse>> call() async {
    try {
      final warehouseModels = await repository.getWarehouses();
      return warehouseModels.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get warehouses: $e');
    }
  }

  Warehouse _mapToEntity(WarehouseModel model) {
    return Warehouse(
      id: model.maKho,
      name: model.tenKho,
      address: model.diaChi,
    );
  }
}