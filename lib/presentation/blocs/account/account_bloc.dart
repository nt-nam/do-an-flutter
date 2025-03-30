import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/user_model.dart';
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
    // Đăng ký các sự kiện
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<FetchAccountProfileEvent>(_onFetchAccountProfile);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<LogoutEvent>(_onLogout);

    // Kiểm tra trạng thái đăng nhập khi khởi tạo
    // _checkLoginStatus();
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoading());
    try {
      final (token, account, user) = await loginUseCase(event.email, event.password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      emit(AccountLoggedIn(token, account, user));
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
      final accountModel = await accountRepository.getAccountById(event.accountId);
      final account = Account(
        id: accountModel.maTK,
        email: accountModel.email,
        password: '',
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
        matKhau: '',
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
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken'); // Xóa token khi đăng xuất
      emit(const AccountLoggedOut());
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  // Future<void> _checkLoginStatus() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('authToken');
  //   if (token != null) {
  //     try {
  //       final (token, account, user) = await loginUseCase.checkLoginStatus(token);
  //       emit(AccountLoggedIn(token, account, user));
  //     } catch (e) {
  //       emit(AccountError(e.toString()));
  //     }
  //   } else {
  //     emit(const AccountInitial());
  //   }
  // }
}