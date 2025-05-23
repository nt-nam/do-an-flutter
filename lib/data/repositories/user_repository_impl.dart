
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

  Future<UserModel> updateUser(UserModel user) async {
    final token = await authService.getToken();
    final response = await apiService.put(
      'nguoidung?id=${user.maND}',
      user.toJson(),
      token: token,
    );
    print('Update user response: $response'); // Debug

    // Kiểm tra trạng thái của phản hồi
    if (response['status'] == 'success' && response['data'] != null) {
      return UserModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Cập nhật người dùng thất bại');
    }
  }
  @override
  Future<UserModel> getUserByAccountId(int accountId) async {
    final token = await authService.getToken();
    try {
      final response = await apiService.get('nguoidung?MaTK=$accountId', token: token);
      print('getUserByAccountId response: $response'); // Debug
      if (response['status'] == 'success' && response['data'] != null) {
        final userData = response['data'];
        if (userData['MaND'] == null || userData['MaND'] <= 0) {
          throw Exception('API response thiếu hoặc MaND không hợp lệ: ${userData['MaND']}');
        }
        if (userData['HoTen'] == null) {
          throw Exception('API response thiếu trường HoTen');
        }
        return UserModel.fromJson(userData);
      } else {
        throw Exception('No user found for MaTK: $accountId');
      }
    } catch (e) {
      print('getUserByAccountId error: $e'); // Debug
      throw Exception('Failed to fetch user by account ID: $e');
    }
  }
}