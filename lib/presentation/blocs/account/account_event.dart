abstract class AccountEvent {
  const AccountEvent();
}

class LoginEvent extends AccountEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);
}

class FetchAccountProfileEvent extends AccountEvent {
  final int accountId;

  const FetchAccountProfileEvent(this.accountId);
}

class UpdateAccountEvent extends AccountEvent {
  final int accountId;
  final String email;
  final String role;
  final bool isActive;

  const UpdateAccountEvent(this.accountId, this.email, this.role, this.isActive);
}

class LogoutEvent extends AccountEvent {
  const LogoutEvent();
}

class RegisterEvent extends AccountEvent {
  final String email;
  final String password;

  const RegisterEvent(this.email, this.password);
}

class FetchAllAccountsEvent extends AccountEvent {
  const FetchAllAccountsEvent();
}

class UpdateAccountRoleEvent extends AccountEvent {
  final int accountId;
  final String newRole;

  const UpdateAccountRoleEvent(this.accountId, this.newRole);
}

