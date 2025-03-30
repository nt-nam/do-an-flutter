import 'package:do_an_flutter/data/models/user_model.dart';
import 'package:do_an_flutter/data/services/api_service.dart';
import 'package:do_an_flutter/data/services/auth_service.dart';
import 'package:do_an_flutter/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final AuthService authService;

  UserRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<UserModel>> getUsers() async {
    final token = await authService.getToken();
    final data = await apiService.get('nguoidung', token: token);
    // API trả về danh sách trực tiếp, không cần 'data'
    return (data as List).map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final token = await authService.getToken();
    final data = await apiService.get('nguoidung/$id', token: token);
    // API trả về object trực tiếp
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    final token = await authService.getToken();
    final data = await apiService.put('nguoidung/${user.maND}', user.toJson(), token: token);
    // API trả về object trực tiếp
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> getUserByAccountId(int accountId) async {
    final token = await authService.getToken();
    try {
      final response = await apiService.get('nguoidung?MaTK=$accountId', token: token);
      print('getUserByAccountId response: $response'); // Debug
      // API trả về {"status": "success", "data": {...}}
      if (response['status'] == 'success' && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      } else {
        throw Exception('No user found for MaTK: $accountId');
      }
    } catch (e) {
      print('getUserByAccountId error: $e'); // Debug
      throw Exception('Failed to fetch user by account ID: $e');
    }
  }
}