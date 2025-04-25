import '../../entities/user.dart';
import '../../repositories/user_repository.dart';
import '../../../data/models/user_model.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<User> call(int accountId) async {
    try {
      final userModel = await repository.getUserByAccountId(accountId);
      return _mapToEntity(userModel);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  User _mapToEntity(UserModel model) {
    return User(
      id: model.maND,
      accountId: model.maTK,
      fullName: model.hoTen,
      phoneNumber: model.sdt,
      address: model.diaChi,
      email: model.email,
      level: model.capDo,
    );
  }
}