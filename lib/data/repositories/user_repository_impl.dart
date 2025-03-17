import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final AuthService authService;

  UserRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<UserModel>> getUsers() async {
    final token = await authService.getToken();
    final data = await apiService.get('nguoidung', token: token);
    return (data as List).map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final token = await authService.getToken();
    final data = await apiService.get('nguoidung/$id', token: token);
    return UserModel.fromJson(data);
  }
  @override
  Future<UserModel> updateUser(UserModel user) async {
    final token = await authService.getToken();
    final data = await apiService.put('nguoidung/${user.maND}', user.toJson(), token: token);
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> getUserByAccountId(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('nguoidung?MaTK=$accountId', token: token);
    return UserModel.fromJson(data);
  }
}