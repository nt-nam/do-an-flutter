import '../models/log_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/log_repository.dart';

class LogRepositoryImpl implements LogRepository {
  final ApiService apiService;
  final AuthService authService;

  LogRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<LogModel>> getLogs() async {
    final token = await authService.getToken();
    final data = await apiService.get('nhatky', token: token);
    return (data as List).map((json) => LogModel.fromJson(json)).toList();
  }

  @override
  Future<LogModel> addLog(LogModel log) async {
    final token = await authService.getToken();
    final data = await apiService.post('nhatky', log.toJson(), token: token);
    return LogModel.fromJson(data);
  }
}