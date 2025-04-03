import '../../../domain/entities/user.dart';

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
  final User user; // Đúng kiểu là User
  const UpdateUser(this.user);
}