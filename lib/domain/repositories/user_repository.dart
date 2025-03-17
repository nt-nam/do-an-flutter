import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
  Future<UserModel> getUserByAccountId(int accountId);
  Future<UserModel> updateUser(UserModel user);
}