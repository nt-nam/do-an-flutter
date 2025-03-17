import '../../data/models/log_model.dart';

abstract class LogRepository {
  Future<List<LogModel>> getLogs();
  Future<LogModel> addLog(LogModel log);
}