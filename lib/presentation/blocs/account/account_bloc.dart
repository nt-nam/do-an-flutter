import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/account_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../domain/entities/account.dart';
import '../../../domain/repositories/account_repository.dart';
import '../../../domain/usecases/get_user_profile_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final LoginUseCase loginUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;
  final AccountRepository accountRepository;
  final AuthService authService;

  AccountBloc(
      this.loginUseCase,
      this.getUserProfileUseCase,
      this.accountRepository,
      this.authService,
      ) : super(const AccountInitial()) {
    on<LoginEvent>(_onLogin);
    on<FetchAccountProfileEvent>(_onFetchAccountProfile);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final (token, account) = await loginUseCase(event.email, event.password);
      emit(AccountLoggedIn(token, account));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> _onFetchAccountProfile(FetchAccountProfileEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final user = await getUserProfileUseCase(event.accountId);
      final accountModel = await accountRepository.getAccountById(event.accountId);
      final account = Account(
        id: accountModel.maTK,
        email: accountModel.email,
        password: '', // Không cần trả mật khẩu
        role: accountModel.vaiTro,
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
      final accountModel = AccountModel(
        maTK: event.accountId,
        email: event.email,
        matKhau: '', // Giả định không cập nhật mật khẩu ở đây
        vaiTro: event.role,
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
}