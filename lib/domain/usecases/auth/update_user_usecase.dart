import '../../../data/models/user_model.dart';
import '../../entities/user.dart';
import '../../repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<User> call(User user) async {
    try {
      final modelUser = UserModel(
        maND: user.id,
        maTK: user.accountId,
        hoTen: user.fullName,
        sdt: user.phoneNumber,
        diaChi: user.address,
        email: user.email,
        capDo: user.level,
      );
      final updatedModel = await repository.updateUser(modelUser);
      return User(
        id: updatedModel.maND,
        accountId: updatedModel.maTK,
        fullName: updatedModel.hoTen,
        phoneNumber: updatedModel.sdt,
        address: updatedModel.diaChi,
        email: updatedModel.email,
        level: updatedModel.capDo,
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}