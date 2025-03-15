// lib/routes.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'models/product_model.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/order_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/review_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/delivery_tracking_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/promotion_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        final authState = BlocProvider.of<AuthBloc>(context).state;

        switch (settings.name) {
          case '/':
            return LoginScreen();
          case '/register':
            return RegisterScreen();
          case '/home':
            if (authState is AuthAuthenticated) {
              switch (authState.user.role) {
                case 'admin':
                  return InventoryScreen();
                case '/delivery':
                  final orderId = settings.arguments as int?; // Nhận orderId từ Navigator
                  return DeliveryTrackingScreen();
                default:
                  return HomeScreen();
              }
            }
            return LoginScreen(); // Chuyển về login nếu chưa xác thực
          case '/product_detail':
            final product = settings.arguments as ProductModel?;
            if (product != null) {
              return ProductDetailScreen(product: product);
            }
            return Scaffold(body: Center(child: Text('Không tìm thấy sản phẩm')));
          case '/cart':
            return CartScreen();
          case '/checkout':
            return CheckoutScreen();
          case '/orders':
            return OrderScreen();
          case '/profile':
            return ProfileScreen();
          case '/reviews':
            final productId = settings.arguments as int?; // Nhận productId từ arguments
            return ReviewScreen(productId: productId ?? 1); // Mặc định productId = 1 nếu null
          case '/notifications':
            return NotificationScreen();
          case '/delivery':
            final orderId = settings.arguments as int?;
            return DeliveryTrackingScreen(orderId: orderId);
          case '/inventory':
            return InventoryScreen();
          case '/promotions':
            return PromotionScreen();
          default:
            return Scaffold(body: Center(child: Text('404 - Trang không tồn tại')));
        }
      },
    );
  }
}