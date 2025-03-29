import '../entities/log.dart';
import '../repositories/log_repository.dart';
import '../../data/models/log_model.dart';

class LogActionUseCase {
  final LogRepository repository;

  LogActionUseCase(this.repository);

  Future<Log> call(int? accountId, String description, String type) async {
    try {
      final logModel = LogModel(
        maNK: 0,
        maTK: accountId,
        moTa: description,
        thoiGian: DateTime.now(),
        loai: type,
      );
      final result = await repository.addLog(logModel);
      return _mapToEntity(result);
    } catch (e) {
      throw Exception('Failed to log action: $e');
    }
  }

  Log _mapToEntity(LogModel model) {
    return Log(
      id: model.maNK,
      accountId: model.maTK,
      description: model.moTa,
      timestamp: model.thoiGian,
      type: LogType.login,
    );
  }
}