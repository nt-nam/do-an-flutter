
import '../../../domain/entities/account.dart';

abstract class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoggedIn extends AccountState {
  final String token;
  final Account account;

  const AccountLoggedIn(this.token, this.account);
}

class AccountProfileLoaded extends AccountState {
  final Account account;

  const AccountProfileLoaded(this.account);
}

class AccountUpdated extends AccountState {
  final Account account;

  const AccountUpdated(this.account);
}

class AccountLoggedOut extends AccountState {
  const AccountLoggedOut();
}

class AccountError extends AccountState {
  final String message;

  const AccountError(this.message);
}