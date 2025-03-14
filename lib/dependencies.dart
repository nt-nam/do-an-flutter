// lib/dependencies.dart
import 'package:get_it/get_it.dart';
import 'services/auth_service.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/product_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/order_bloc.dart';
import 'blocs/review_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/delivery_bloc.dart';
import 'blocs/inventory_bloc.dart';
import 'blocs/promotion_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => AuthService());
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => ProductBloc());
  sl.registerFactory(() => CartBloc());
  sl.registerFactory(() => OrderBloc());
  // sl.registerFactory(() => ReviewBloc());
  // sl.registerFactory(() => NotificationBloc());
  // sl.registerFactory(() => DeliveryBloc());
  // sl.registerFactory(() => InventoryBloc());
  // sl.registerFactory(() => PromotionBloc());
}