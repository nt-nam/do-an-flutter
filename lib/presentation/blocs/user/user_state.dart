import '../../../data/models/user_model.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UsersLoaded extends UserState {
  final List<UserModel> users;
  const UsersLoaded(this.users);
}

class UserLoaded extends UserState {
  final UserModel user;
  const UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);
}