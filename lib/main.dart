import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gas_store/domain/usecases/notification/create_notifications_usecase.dart';
import 'package:gas_store/domain/usecases/notification/delete_notification_usecase.dart';
import 'package:gas_store/domain/usecases/notification/get_active_notifications_count_usecase.dart';
import 'package:gas_store/domain/usecases/notification/get_system_notifications_usecase.dart';
import 'package:gas_store/domain/usecases/notification/update_notification_usecase.dart';
import '../presentation/blocs/offer/offer_bloc.dart';
import '../presentation/blocs/user/user_bloc.dart';
import '../presentation/blocs/account/account_bloc.dart';
import '../presentation/blocs/account/account_state.dart';
import '../presentation/blocs/cart/cart_bloc.dart';
import '../presentation/blocs/category/category_bloc.dart';
import '../presentation/blocs/category/category_event.dart';
import '../presentation/blocs/product/product_bloc.dart';
import '../presentation/blocs/settings/settings_bloc.dart';
import '../presentation/blocs/settings/settings_state.dart';
import '../presentation/pages/screens/MainScreen.dart';
import '../presentation/pages/screens/auth/LoginScreen.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/cart_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'data/repositories/offer_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';
import 'domain/entities/settings.dart';
import 'domain/usecases/auth/update_user_usecase.dart';
import 'domain/usecases/cart/add_to_cart_usecase.dart';
import 'domain/usecases/cart/get_cart_usecase.dart';
import 'domain/usecases/cart/remove_from_cart_usecase.dart';
import 'domain/usecases/cart/update_cart_quantity_usecase.dart';
import 'domain/usecases/category/add_category_usecase.dart';
import 'domain/usecases/category/delete_category_usecase.dart';
import 'domain/usecases/category/update_category_usecase.dart';
import 'domain/usecases/offer/add_offer_usecase.dart';
import 'domain/usecases/offer/get_offers_usecase.dart';
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
import 'domain/usecases/notification/mark_notification_as_read_usecase.dart';
import 'presentation/blocs/notification/notification_bloc.dart';

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
    final updateUserUseCase = UpdateUserUseCase(userRepository);
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
    // Cart-related dependencies
    final cartRepository = CartRepositoryImpl(apiService, authService);
    final getCartUseCase = GetCartUseCase(cartRepository);
    final addToCartUseCase = AddToCartUseCase(cartRepository,productRepository);
    final removeFromCartUseCase = RemoveFromCartUseCase(cartRepository);
    final updateCartQuantityUseCase = UpdateCartQuantityUseCase(cartRepository);

    // Thêm OrderRepository và các UseCase cho OrderBloc
    final orderRepository = OrderRepositoryImpl(apiService, authService);
    final getOrdersUseCase = GetOrdersUseCase(orderRepository);
    final createOrderUseCase = CreateOrderUseCase(
      orderRepository: orderRepository,
      cartRepository: cartRepository, // Thêm cartRepository
    );
    final updateOrderStatusUseCase = UpdateOrderStatusUseCase(orderRepository);
    final getOrderDetailsUseCase = GetOrderDetailsUseCase(orderRepository);


    // Offer-related dependencies - Thêm mới
    final offerRepository = OfferRepositoryImpl(apiService, authService);
    final getOffersUseCase = GetOffersUseCase(offerRepository);
    final addOfferUseCase = AddOfferUseCase(offerRepository);

    // Notification-related dependencies
    final notificationRepository = NotificationRepositoryImpl(apiService, authService);
    final createNotificationUseCase = CreateNotificationUseCase(notificationRepository);
    final deleteNotificationUseCase=DeleteNotificationUseCase(notificationRepository);
    final getActiveNotificationsCountUseCase=GetActiveNotificationsCountUseCase(notificationRepository);
    final getSystemNotificationsUseCase=GetSystemNotificationsUseCase(notificationRepository);
    final markNotificationAsReadUseCase = MarkNotificationAsReadUseCase(notificationRepository);
    final updateNotificationUseCase = UpdateNotificationUseCase(notificationRepository);

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
          create: (context) => UserBloc(
            userRepository,
            /*loginUseCase,
            registerUseCase,
            getUserProfileUseCase,
            accountRepository,
            authService,*/
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
          create: (context) => CartBloc(
            getCartUseCase: getCartUseCase,
            addToCartUseCase: addToCartUseCase,
            removeFromCartUseCase: removeFromCartUseCase,
            updateCartQuantityUseCase: updateCartQuantityUseCase,
          ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider(
          create: (context) => OfferBloc(
            getOffersUseCase,
            addOfferUseCase,
            offerRepository,
          ),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(
            createNotificationUseCase: createNotificationUseCase,
            deleteNotificationUseCase: deleteNotificationUseCase,
            getActiveNotificationsCountUseCase: getActiveNotificationsCountUseCase,
            getSystemNotificationsUseCase: getSystemNotificationsUseCase,
            markNotificationAsReadUseCase: markNotificationAsReadUseCase,
            updateNotificationUseCase: updateNotificationUseCase
          ),
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
      case ThemeColor.Teal:
        return Colors.teal;
      case ThemeColor.Blue:
        return Colors.blue;
      case ThemeColor.Red:
        return Colors.red;
    }
  }
}