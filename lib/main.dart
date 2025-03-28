import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_bloc.dart'; // Thêm import CategoryBloc
import 'package:do_an_flutter/presentation/pages/screens/auth/LoginScreen.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart'; // Thêm import CategoryRepositoryImpl
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/usecases/add_category_usecase.dart'; // Thêm import AddCategoryUseCase
import 'domain/usecases/delete_category_usecase.dart'; // Thêm import DeleteCategoryUseCase
import 'domain/usecases/get_categories_usecase.dart'; // Thêm import GetCategoriesUseCase
import 'domain/usecases/get_user_profile_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_use_case.dart';
import 'domain/usecases/update_category_usecase.dart'; // Thêm import UpdateCategoryUseCase

void main() {
  final apiService = ApiService();
  final authService = AuthService();
  final accountRepository = AccountRepositoryImpl(apiService, authService);
  final userRepository = UserRepositoryImpl(apiService, authService);
  final loginUseCase = LoginUseCase(authService,userRepository);
  final registerUseCase = RegisterUseCase(authService);
  final getUserProfileUseCase = GetUserProfileUseCase(userRepository);

  // Thêm các dependency cho CategoryBloc
  final categoryRepository = CategoryRepositoryImpl();
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
  final addCategoryUseCase = AddCategoryUseCase(categoryRepository);
  final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
  final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AccountBloc(
            loginUseCase,
            registerUseCase,
            getUserProfileUseCase,
            accountRepository,
            authService,
          ),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(
            getCategoriesUseCase,
            addCategoryUseCase,
            updateCategoryUseCase,
            deleteCategoryUseCase,
          ),
        ),
      ],
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