// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dependencies.dart' as di;
import 'blocs/auth_bloc.dart';
import 'blocs/product_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/order_bloc.dart';
import 'blocs/review_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/delivery_bloc.dart';
import 'blocs/inventory_bloc.dart';
import 'blocs/promotion_bloc.dart';
import 'utils/app_theme.dart'; // Import appTheme
import 'routes.dart';

void main() async {
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<ProductBloc>()),
        BlocProvider(create: (_) => di.sl<CartBloc>()),
        BlocProvider(create: (_) => di.sl<OrderBloc>()),
        // BlocProvider(create: (_) => di.sl<ReviewBloc>()),
        // BlocProvider(create: (_) => di.sl<NotificationBloc>()),
        BlocProvider(create: (_) => di.sl<DeliveryBloc>()),
        // BlocProvider(create: (_) => di.sl<InventoryBloc>()),
        // BlocProvider(create: (_) => di.sl<PromotionBloc>()),
      ],
      child: MaterialApp(
        title: 'Gas Delivery App',
        theme: appTheme, // Sử dụng appTheme từ utils/app_theme.dart
        initialRoute: '/',
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}