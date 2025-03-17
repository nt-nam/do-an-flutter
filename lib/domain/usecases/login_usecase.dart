import '../entities/account.dart';
import '../../data/models/account_model.dart';
import '../../data/services/auth_service.dart';

class LoginUseCase {
  final AuthService authService;

  LoginUseCase(this.authService);

  Future<(String, Account)> call(String email, String password) async {
    try {
      final token = await authService.login(email, password);
      // Giả định API trả về cả thông tin tài khoản sau khi đăng nhập
      final accountData = {'MaTK': 1, 'Email': email, 'VaiTro': 'Khách hàng', 'TrangThai': true};
      final accountModel = AccountModel.fromJson(accountData);
      return (token, _mapToEntity(accountModel));
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Account _mapToEntity(AccountModel model) {
    return Account(
      id: model.maTK,
      email: model.email,
      password: '', // Không cần trả mật khẩu
      role: model.vaiTro,
      isActive: model.trangThai,
    );
  }
}