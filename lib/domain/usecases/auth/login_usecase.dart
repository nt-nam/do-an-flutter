import '../../entities/account.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../repositories/user_repository.dart';

class LoginUseCase {
  final AuthService authService;
  final UserRepository userRepository;

  LoginUseCase(this.authService, this.userRepository);

  Future<(String, Account, UserModel?)> call(String email, String password) async {
    try {
      final response = await authService.login(email, password);
      final token = response['token'] as String? ?? '';
      final userData = response['user'] as Map<String, dynamic>?;

      if (userData == null) {
        throw Exception('User data not found in API response');
      }

      final accountModel = AccountModel.fromJson(userData);
      final account = _mapToEntity(accountModel);

      UserModel? user;
      try {
        user = await userRepository.getUserByAccountId(account.id);
      } catch (e) {
        user = null;
      }

      return (token, account, user);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Future<(String, Account, UserModel?)> checkLoginStatus(String token) async {
  //   try {
  //     final account = await authService.validateToken(token);
  //     final user = await userRepository.getUserProfile(token);
  //     return (token, account, user);
  //   } catch (e) {
  //     throw Exception('Token validation failed: $e');
  //   }
  // }

  Account _mapToEntity(AccountModel model) {
    return Account(
      id: model.maTK,
      email: model.email,
      password: '',
      role: model.vaiTro,
      isActive: model.trangThai,
    );
  }
}