import '../models/account_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final ApiService apiService;
  final AuthService authService;

  AccountRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<AccountModel>> getAccounts() async {
    final token = await authService.getToken();
    final data = await apiService.get('taikhoan', token: token);
    return (data as List).map((json) => AccountModel.fromJson(json)).toList();
  }

  @override
  Future<AccountModel> getAccountById(int id) async {
    final token = await authService.getToken();
    final data = await apiService.get('taikhoan/$id', token: token);
    return AccountModel.fromJson(data);
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    final token = await authService.getToken();
    final data = await apiService.put('taikhoan/${account.maTK}', account.toJson(), token: token);
    return AccountModel.fromJson(data);
  }

  @override
  Future<void> deleteAccount(int id) async {
    final token = await authService.getToken();
    await apiService.delete('taikhoan/$id', token: token);
  }
}