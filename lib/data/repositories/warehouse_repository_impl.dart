import '../models/warehouse_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/warehouse_repository.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final ApiService apiService;
  final AuthService authService;

  WarehouseRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<WarehouseModel>> getWarehouses() async {
    final token = await authService.getToken();
    final data = await apiService.get('khohang', token: token);
    return (data as List).map((json) => WarehouseModel.fromJson(json)).toList();
  }

  @override
  Future<WarehouseModel> getWarehouseById(int id) async {
    final token = await authService.getToken();
    final data = await apiService.get('khohang/$id', token: token);
    return WarehouseModel.fromJson(data);
  }

  @override
  Future<WarehouseModel> createWarehouse(WarehouseModel warehouse) async {
    final token = await authService.getToken();
    final data = await apiService.post('khohang', warehouse.toJson(), token: token);
    return WarehouseModel.fromJson(data);
  }

  @override
  Future<WarehouseModel> updateWarehouse(WarehouseModel warehouse) async {
    final token = await authService.getToken();
    final data = await apiService.put('khohang/${warehouse.maKho}', warehouse.toJson(), token: token);
    return WarehouseModel.fromJson(data);
  }

  @override
  Future<void> deleteWarehouse(int id) async {
    final token = await authService.getToken();
    await apiService.delete('khohang/$id', token: token);
  }
}