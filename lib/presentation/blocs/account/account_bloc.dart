import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/account_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/repositories/account_repository.dart';
import '../../../domain/usecases/auth/get_user_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_use_case.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final AccountRepository accountRepository;
  final AuthService authService;

  AccountBloc(
      this.loginUseCase,
      this.registerUseCase,
      this.getUserProfileUseCase,
      this.accountRepository,
      this.authService,
      ) : super(const AccountInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<FetchAccountProfileEvent>(_onFetchAccountProfile);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final (token, account, user) = await loginUseCase(event.email, event.password);
      emit(AccountLoggedIn(token, account, user ));
      print('Login success: token=$token, account=$account, user=$user');
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final account = await registerUseCase(event.email, event.password);
      emit(AccountRegistered(account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onFetchAccountProfile(FetchAccountProfileEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      // final user = await getUserProfileUseCase(event.accountId);
      final accountModel = await accountRepository.getAccountById(event.accountId);
      final account = Account(
        id: accountModel.maTK,
        email: accountModel.email, // Đã đảm bảo không null
        password: '', // Không cần trả mật khẩu
        role: accountModel.vaiTro, // Đã đảm bảo không null
        isActive: accountModel.trangThai,
      );
      emit(AccountProfileLoaded(account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onUpdateAccount(UpdateAccountEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final currentAccount = await accountRepository.getAccountById(event.accountId);
      final accountModel = AccountModel(
        maTK: event.accountId,
        email: event.email ?? currentAccount.email,
        matKhau: currentAccount.matKhau, // Giữ nguyên mật khẩu cũ
        vaiTro: event.role ?? currentAccount.vaiTro,
        trangThai: event.isActive,
      );
      final updatedAccountModel = await accountRepository.updateAccount(accountModel);
      final updatedAccount = Account(
        id: updatedAccountModel.maTK,
        email: updatedAccountModel.email,
        password: '',
        role: updatedAccountModel.vaiTro,
        isActive: updatedAccountModel.trangThai,
      );
      emit(AccountUpdated(updatedAccount));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      await authService.logout();
      emit(const AccountLoggedOut());
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onFetchAllAccounts(FetchAllAccountsEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      if (state is! AccountLoggedIn) {
        throw Exception('Unauthorized');
      }

      final loggedInAccount = (state as AccountLoggedIn).account;
      if (loggedInAccount.role != 'Quản trị') {
        throw Exception('Permission denied');
      }

      final accounts = await accountRepository.getAccounts();
      emit(AllAccountsLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onUpdateAccountRole(UpdateAccountRoleEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      if (state is! AccountLoggedIn) {
        throw Exception('Unauthorized');
      }

      final loggedInAccount = (state as AccountLoggedIn).account;
      if (loggedInAccount.role != 'Quản trị') {
        throw Exception('Permission denied');
      }

      final targetAccount = await accountRepository.getAccountById(event.accountId);

      // Prevent modifying admin accounts (role 3)
      if (targetAccount.vaiTro == 'Quản trị') {
        throw Exception('Cannot modify admin accounts');
      }

      // Only allow changing between role 1 and 2
      if (event.newRole != 'Khách hàng' && event.newRole != 'Nhân viên') {
        throw Exception('Invalid role');
      }

      final updatedAccount = AccountModel(
        maTK: targetAccount.maTK,
        email: targetAccount.email,
        matKhau: targetAccount.matKhau,
        vaiTro: event.newRole,
        trangThai: targetAccount.trangThai,
      );

      await accountRepository.updateAccount(updatedAccount);
      emit(AccountRoleUpdated(updatedAccount));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}