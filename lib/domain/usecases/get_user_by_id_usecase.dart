import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserById{
  final UserRepository repository;

  GetUserById(this.repository);

  Future<User> call(int id) async {
    try {
      final modelUser = await repository.getUserById(id);
      return User(
        id: modelUser.maND,
        accountId: modelUser.maTK,
        fullName: modelUser.hoTen,
        phoneNumber: modelUser.sdt,
        address: modelUser.diaChi,
      );
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }
}