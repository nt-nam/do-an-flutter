import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas_store/presentation/pages/screens/notifiction/ListNotificationScreen.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../widgets/NavigationBottom.dart';
import 'CartScreen.dart';
import 'HomeScreen.dart';
import 'product/FindProductScreen.dart';
import 'order/OrderScreen.dart';
import 'MenuScreen.dart'; // Giả sử bạn có CartScreen và NotificationScreen sau này

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = [
    const HomeScreen(),
    FindProductScreen(),
    const CartScreen(),
    const ListNotificationScreen(),
    const OrderScreen(),
  ];

  void _onItemTapped(int index) {
    if (_currentIndex == 1 && index != 1) { // Kiểm tra khi rời khỏi FindProductScreen
      context.read<ProductBloc>().add(const ResetProductsEvent()); // Gửi sự kiện reset
    }
    setState(() {
      _currentIndex = index; // Cập nhật index hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}