import 'dart:convert';
import 'package:http/http.dart' as http;
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
    if (token == null) throw Exception('Authentication token is missing');
    final response = await apiService.get('accounts.php', token: token);
    if (response['status'] == 'success') {
      return (response['data'] as List).map((json) => AccountModel.fromJson(json)).toList();
    }
    throw Exception('Failed to fetch accounts: ${response['message']}');
  }

  @override
  Future<AccountModel> getAccountById(int id) async {
    final token = await authService.getToken();
    final response = await apiService.get('accounts.php?maTK=$id', token: token);
    if (response['status'] == 'success') {
      return AccountModel.fromJson(response['data']);
    }
    throw Exception('Failed to fetch account: ${response['message']}');
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    final token = await authService.getToken();
    final response = await apiService.put(
      'accounts.php?maTK=${account.maTK}',
      account.toJson(),
      token: token,
    );
    if (response['status'] == 'success') {
      return AccountModel.fromJson(response['data']);
    }
    throw Exception('Failed to update account: ${response['message']}');
  }

  @override
  Future<void> deleteAccount(int id) async {
    throw UnimplementedError('Delete account not supported by backend');
  }
}