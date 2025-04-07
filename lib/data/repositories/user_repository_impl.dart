
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final AuthService authService;

  UserRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<UserModel>> getUsers() async {
    final token = await authService.getToken();
    final response = await apiService.get('users.php', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => UserModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch users: ${response['message']}');
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final token = await authService.getToken();
    final response = await apiService.get('users.php?id=$id', token: token);
    if (response['status'] == 'success') {
      return UserModel.fromJson(response['data']);
    }
    throw Exception('Failed to fetch user: ${response['message']}');
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final token = await authService.getToken();
    final response = await apiService.put('users.php?id=${user.maND}', user.toJson(), token: token);
    if (response['status'] == 'success') {
      return UserModel.fromJson(response['data']);
    }
    throw Exception('Failed to update user: ${response['message']}');
  }

  @override
  Future<UserModel> getUserByAccountId(int accountId) async {
    final token = await authService.getToken();
    final response = await apiService.get('users.php?MaTK=$accountId', token: token);
    if (response['status'] == 'success' && response['data'] != null) {
      return UserModel.fromJson(response['data']);
    }
    throw Exception('No user found for MaTK: $accountId');
  }
}