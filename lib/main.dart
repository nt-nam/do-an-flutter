import 'package:do_an_flutter/domain/usecases/category/add_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/category/delete_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/category/update_category_usecase.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_event.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_event.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart';
import 'package:do_an_flutter/presentation/pages/screens/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/usecases/product/add_product_usecase.dart';
import 'domain/usecases/product/delete_product_usecase.dart';
import 'domain/usecases/category/get_categories_usecase.dart';
import 'domain/usecases/product/get_product_by_id_usecase.dart';
import 'domain/usecases/product/get_products_usecase.dart';
import 'domain/usecases/auth/get_user_usecase.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_use_case.dart';
import 'domain/usecases/product/update_product_usecase.dart';

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
  final getProductsByIdUseCase = GetProductByIdUsecase(productRepository);
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
            getProductByIdUsecase: getProductsByIdUseCase,
          )..add(const FetchProductsEvent()),
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
