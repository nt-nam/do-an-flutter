import '../../entities/account.dart';
import '../../../data/models/account_model.dart';
import '../../../data/services/auth_service.dart';

class RegisterUseCase {
  final AuthService authService;

  RegisterUseCase(this.authService);

  Future<Account> call(String email, String password) async {
    try {
      final response = await authService.register(email, password);
      final userData = response['user'] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('User data not found in API response');
      }

      // Dữ liệu từ API đã được ánh xạ đúng trong AccountModel.fromJson
      final accountModel = AccountModel.fromJson(userData);
      return _mapToEntity(accountModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
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