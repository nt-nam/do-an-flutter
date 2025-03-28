import 'package:do_an_flutter/domain/usecases/add_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/delete_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/update_category_usecase.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_event.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_event.dart';
import 'package:do_an_flutter/presentation/pages/screens/LoginScreen.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart'; // Thêm import HomeScreen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/add_product_usecase.dart';
import 'domain/usecases/delete_product_usecase.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_use_case.dart';
import 'domain/usecases/update_product_usecase.dart';

void main() {
  final apiService = ApiService();
  final authService = AuthService();
  final accountRepository = AccountRepositoryImpl(apiService, authService);
  final userRepository = UserRepositoryImpl(apiService, authService);
  final loginUseCase = LoginUseCase(authService, userRepository);
  final registerUseCase = RegisterUseCase(authService);
  final getUserProfileUseCase = GetUserProfileUseCase(userRepository);

  final categoryRepository = CategoryRepositoryImpl(apiService, authService);
  final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
  final addCategoryUseCase = AddCategoryUseCase(categoryRepository);
  final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
  final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);

  final productRepository = ProductRepositoryImpl(apiService, authService);
  final getProductsUseCase = GetProductsUseCase(productRepository);
  final addProductsUseCase = AddProductUseCase(productRepository);
  final updateProductsUseCase = UpdateProductUseCase(productRepository);
  final deleteProductsUseCase = DeleteProductUseCase(productRepository);

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
          )..add(
              const FetchCategoriesEvent()), // Tự động fetch categories khi khởi tạo
        ),
        BlocProvider(
          create: (context) => ProductBloc(
              getProductsUseCase: getProductsUseCase,
              addProductUseCase: addProductsUseCase,
              updateProductUseCase: updateProductsUseCase,
              deleteProductUseCase: deleteProductsUseCase,
              productRepository: productRepository)
            ..add(
                const FetchProductsEvent()), // Tự động fetch product khi khởi tạo
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
