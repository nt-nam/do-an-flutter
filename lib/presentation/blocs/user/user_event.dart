import '../../../data/models/user_model.dart';

abstract class UserEvent {
  const UserEvent();
}

class LoadUsers extends UserEvent {
  const LoadUsers();
}

class LoadUserById extends UserEvent {
  final int id;
  const LoadUserById(this.id);
}

class LoadUserByAccountId extends UserEvent {
  final int accountId;
  const LoadUserByAccountId(this.accountId);
}

class UpdateUser extends UserEvent {
  final UserModel user;
  const UpdateUser(this.user);
}