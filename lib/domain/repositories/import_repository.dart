import '../../data/models/import_model.dart';

abstract class ImportRepository {
  Future<List<ImportModel>> getImports();
  Future<List<ImportModel>> getImportsByWarehouse(int warehouseId);
  Future<ImportModel> createImport(ImportModel importModel);
}