// lib/dependencies.dart
import 'package:get_it/get_it.dart';
import 'core/services/api_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/local_storage.dart';
import 'core/services/notification_service.dart';
import 'core/services/location_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/delivery_repository.dart';
import 'data/repositories/inventory_repository.dart';
import 'data/repositories/promotion_repository.dart';
import 'logic/authentication/auth_bloc.dart';
import 'logic/products/product_bloc.dart';
import 'logic/cart/cart_bloc.dart';
import 'logic/orders/order_bloc.dart';
import 'logic/reviews/review_bloc.dart';
import 'logic/notifications/notification_bloc.dart';
import 'logic/delivery/delivery_bloc.dart';
import 'logic/inventory/inventory_bloc.dart';
import 'logic/promotions/promotion_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => ApiService(sl()));
  sl.registerLazySingleton(() => LocalStorage());
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => NotificationService());
  sl.registerLazySingleton(() => LocationService());

  // Repositories
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => ProductRepository(sl()));
  sl.registerLazySingleton(() => OrderRepository(sl()));
  sl.registerLazySingleton(() => CartRepository(sl()));
  sl.registerLazySingleton(() => UserRepository(sl()));
  sl.registerLazySingleton(() => ReviewRepository(sl()));
  sl.registerLazySingleton(() => PaymentRepository(sl()));
  sl.registerLazySingleton(() => DeliveryRepository(sl())); // Mới
  sl.registerLazySingleton(() => InventoryRepository(sl())); // Mới
  sl.registerLazySingleton(() => PromotionRepository(sl())); // Mới

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => ProductBloc(sl()));
  sl.registerFactory(() => CartBloc(sl()));
  sl.registerFactory(() => OrderBloc(sl()));
  sl.registerFactory(() => ReviewBloc(sl()));
  sl.registerFactory(() => NotificationBloc(sl()));
  sl.registerFactory(() => DeliveryBloc(sl())); // Mới
  sl.registerFactory(() => InventoryBloc(sl())); // Mới
  sl.registerFactory(() => PromotionBloc(sl())); // Mới
}