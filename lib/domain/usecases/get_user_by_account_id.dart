import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByAccountId {
  final UserRepository repository;

  GetUserByAccountId(this.repository);

  Future<User> call(int accountId) async {
    try {
      final modelUser = await repository.getUserByAccountId(accountId);
      return User(
        id: modelUser.maND,
        accountId: modelUser.maTK,
        fullName: modelUser.hoTen,
        phoneNumber: modelUser.sdt,
        address: modelUser.diaChi,
        email: modelUser.email, // Thêm email
      );
    } catch (e) {
      throw Exception('Failed to get user by account id: $e');
    }
  }
}