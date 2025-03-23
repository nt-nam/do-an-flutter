import '../entities/account.dart';
import '../../data/models/account_model.dart';
import '../../data/services/auth_service.dart';

class LoginUseCase {
  final AuthService authService;

  LoginUseCase(this.authService);

  Future<(String, Account)> call(String email, String password) async {
    try {
      final response = await authService.login(email, password);
      final token = response['token'] as String? ?? ''; // Giả định API trả về token
      final userData = response['user'] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('User data not found in API response');
      }

      // Dữ liệu từ API đã được ánh xạ đúng trong AccountModel.fromJson
      final accountModel = AccountModel.fromJson(userData);
      return (token, _mapToEntity(accountModel));
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Account _mapToEntity(AccountModel model) {
    return Account(
      id: model.maTK,
      email: model.email, // Đã đảm bảo không null trong AccountModel
      password: '', // Không cần trả mật khẩu
      role: model.vaiTro, // Đã đảm bảo không null trong AccountModel
      isActive: model.trangThai,
    );
  }
}