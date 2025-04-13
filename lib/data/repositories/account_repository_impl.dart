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
    if (token == null) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }
    final data = await apiService.get('taikhoan', token: token);
    return (data['data'] as List).map((json) => AccountModel.fromJson(json)).toList();
    // return (data as List).map((json) => AccountModel.fromJson(json)).toList();
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
    final data = await apiService.put(
      'taikhoan',
      {'maTK': account.maTK, 'vaiTro': account.vaiTro}, // Gửi dữ liệu dạng {maTK: 1, vaiTro: 2}
      token: token,
    );
    return account; // Hoặc xử lý response từ server nếu cần

    //   final data = await apiService.put('taikhoan/${account.maTK}', account.toJson(), token: token);
    //   return AccountModel.fromJson(data);
  }

  @override
  Future<void> deleteAccount(int id) async {
    final token = await authService.getToken();
    await apiService.delete('taikhoan/$id', token: token);
  }

  @override
  Future<String> getCartId(String accountId) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found. Please login first.');
    }

    final data = await apiService.get('giohang?MaTK=$accountId', token: token);
    if (data['status'] != 'success') {
      throw Exception('Failed to get cart: ${data['message']}');
    }

    final cartId = data['data']['MaGH'].toString();
    if (cartId == null) {
      throw Exception('Cart ID not found in response');
    }

    return cartId;
  }
}