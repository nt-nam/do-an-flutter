import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> call() async {
    try {
      final userModels = await repository.getUsers();
      return userModels.map((modelUser) => User(
        id: modelUser.maND,
        accountId: modelUser.maTK,
        fullName: modelUser.hoTen,
        phoneNumber: modelUser.sdt,
        address: modelUser.diaChi,
      )).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }
}