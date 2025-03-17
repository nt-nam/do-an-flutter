import '../../data/models/warehouse_model.dart';

abstract class WarehouseRepository {
  Future<List<WarehouseModel>> getWarehouses();
  Future<WarehouseModel> getWarehouseById(int id);
  Future<WarehouseModel> createWarehouse(WarehouseModel warehouse);
  Future<WarehouseModel> updateWarehouse(WarehouseModel warehouse);
  Future<void> deleteWarehouse(int id);
}