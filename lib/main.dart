import 'package:do_an_flutter/presentation/pages/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:do_an_flutter/domain/usecases/category/add_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/category/delete_category_usecase.dart';
import 'package:do_an_flutter/domain/usecases/category/update_category_usecase.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/account/account_state.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/category/category_event.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/product/product_event.dart';
import 'package:do_an_flutter/presentation/blocs/settings/settings_bloc.dart';
import 'package:do_an_flutter/presentation/blocs/settings/settings_state.dart';
import 'package:do_an_flutter/presentation/pages/screens/HomeScreen.dart';
import 'package:do_an_flutter/presentation/pages/screens/auth/LoginScreen.dart';
import 'package:do_an_flutter/domain/entities/settings.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/usecases/order/create_order_usecase.dart';
import 'domain/usecases/order/get_order_details_usecase.dart';
import 'domain/usecases/order/get_orders_usecase.dart';
import 'domain/usecases/order/update_order_status_usecase.dart';
import 'domain/usecases/product/add_product_usecase.dart';
import 'domain/usecases/product/delete_product_usecase.dart';
import 'domain/usecases/category/get_categories_usecase.dart';
import 'domain/usecases/product/get_product_by_id_usecase.dart';
import 'domain/usecases/product/get_products_usecase.dart';
import 'domain/usecases/auth/get_user_usecase.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/register_use_case.dart';
import 'domain/usecases/product/update_product_usecase.dart';
import 'presentation/blocs/order/order_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final authService = AuthService();

    // Account-related dependencies
    final accountRepository = AccountRepositoryImpl(apiService, authService);
    final userRepository = UserRepositoryImpl(apiService, authService);
    final loginUseCase = LoginUseCase(authService, userRepository);
    final registerUseCase = RegisterUseCase(authService);
    final getUserProfileUseCase = GetUserProfileUseCase(userRepository);

    // Category-related dependencies
    final categoryRepository = CategoryRepositoryImpl(apiService, authService);
    final getCategoriesUseCase = GetCategoriesUseCase(categoryRepository);
    final addCategoryUseCase = AddCategoryUseCase(categoryRepository);
    final updateCategoryUseCase = UpdateCategoryUseCase(categoryRepository);
    final deleteCategoryUseCase = DeleteCategoryUseCase(categoryRepository);

    // Product-related dependencies
    final productRepository = ProductRepositoryImpl(apiService, authService);
    final getProductsUseCase = GetProductsUseCase(productRepository);
    final getProductsByIdUseCase = GetProductByIdUsecase(productRepository);
    final addProductsUseCase = AddProductUseCase(productRepository);
    final updateProductsUseCase = UpdateProductUseCase(productRepository);
    final deleteProductsUseCase = DeleteProductUseCase(productRepository);

    // Thêm OrderRepository và các UseCase cho OrderBloc
    final orderRepository = OrderRepositoryImpl(apiService, authService);
    final getOrdersUseCase = GetOrdersUseCase(orderRepository);
    final createOrderUseCase = CreateOrderUseCase(orderRepository);
    final updateOrderStatusUseCase = UpdateOrderStatusUseCase(orderRepository);
    final getOrderDetailsUseCase = GetOrderDetailsUseCase(orderRepository);

    return MultiBlocProvider(
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
          )..add(const FetchCategoriesEvent()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            getProductsUseCase: getProductsUseCase,
            addProductUseCase: addProductsUseCase,
            updateProductUseCase: updateProductsUseCase,
            deleteProductUseCase: deleteProductsUseCase,
            getProductByIdUsecase: getProductsByIdUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => OrderBloc(
            getOrdersUseCase: getOrdersUseCase,
            createOrderUseCase: createOrderUseCase,
            updateOrderStatusUseCase: updateOrderStatusUseCase,
            getOrderDetailsUseCase: getOrderDetailsUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: _getMaterialColor(settingsState.settings.themeColor),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: _getMaterialColor(settingsState.settings.themeColor),
              brightness: Brightness.dark,
            ),
            themeMode: settingsState.settings.themeMode == ThemeModeOption.light
                ? ThemeMode.light
                : ThemeMode.dark,
            locale: settingsState.settings.language == Language.vietnamese
                ? const Locale('vi', 'VN')
                : const Locale('en', 'US'),
            supportedLocales: const [
              Locale('vi', 'VN'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                if (accountState is AccountLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ); // Hiển thị loading khi đang kiểm tra trạng thái
                } else if (accountState is AccountLoggedIn) {
                  return MainScreen();
                } else if (accountState is AccountLoggedOut || accountState is AccountInitial) {
                  return LoginScreen();
                } else if (accountState is AccountError) {
                  return LoginScreen(); // Quay lại LoginScreen nếu có lỗi
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ); // Mặc định hiển thị loading
              },
            ),
          );
        },
      ),
    );
  }

  MaterialColor _getMaterialColor(ThemeColor color) {
    switch (color) {
      case ThemeColor.teal:
        return Colors.teal;
      case ThemeColor.blue:
        return Colors.blue;
      case ThemeColor.red:
        return Colors.red;
    }
  }
}