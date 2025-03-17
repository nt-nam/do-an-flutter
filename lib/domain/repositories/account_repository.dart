import '../../data/models/account_model.dart';

abstract class AccountRepository {
  Future<List<AccountModel>> getAccounts();
  Future<AccountModel> getAccountById(int id);
  Future<AccountModel> updateAccount(AccountModel account);
  Future<void> deleteAccount(int id);
}