import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/pages/screens/LoginScreen.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart'; // Thêm import HomeScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_use_case.dart';

void main() {
  final apiService = ApiService();
  final authService = AuthService();
  final accountRepository = AccountRepositoryImpl(apiService, authService);
  final userRepository = UserRepositoryImpl(apiService, authService);
  final loginUseCase = LoginUseCase(authService,userRepository);
  final registerUseCase = RegisterUseCase(authService);
  final getUserProfileUseCase = GetUserProfileUseCase(userRepository);

  runApp(
    BlocProvider(
      create: (context) => AccountBloc(
        loginUseCase,
        registerUseCase,
        getUserProfileUseCase,
        accountRepository,
        authService,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          // Nếu trạng thái là đăng nhập thành công, chuyển sang HomeScreen
          if (state is AccountLoggedIn) {
            return HomeScreen();
          }
          // Mặc định hiển thị LoginScreen
          return LoginScreen();
        },
      ),
    );
  }
}