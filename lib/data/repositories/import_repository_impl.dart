import '../models/import_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/import_repository.dart';

class ImportRepositoryImpl implements ImportRepository {
  final ApiService apiService;
  final AuthService authService;

  ImportRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<ImportModel>> getImports() async {
    final token = await authService.getToken();
    final data = await apiService.get('nhaphang', token: token);
    return (data as List).map((json) => ImportModel.fromJson(json)).toList();
  }

  @override
  Future<ImportModel> createImport(ImportModel importModel) async {
    final token = await authService.getToken();
    final data = await apiService.post('nhaphang', importModel.toJson(), token: token);
    return ImportModel.fromJson(data);
  }

  @override
  Future<List<ImportModel>> getImportsByWarehouse(int warehouseId) async {
    final token = await authService.getToken();
    final data = await apiService.get('nhaphang?MaKho=$warehouseId', token: token);
    return (data as List).map((json) => ImportModel.fromJson(json)).toList();
  }
}