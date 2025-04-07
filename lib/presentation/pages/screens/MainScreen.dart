import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../widgets/NavigationBottom.dart';
import 'CartScreen.dart';
import 'HomeScreen.dart';
import 'product/FindProductScreen.dart';
import 'OrderScreen.dart';
import 'MenuScreen.dart'; // Giả sử bạn có CartScreen và NotificationScreen sau này

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    FindProductScreen(),
    const CartScreen(),
    const Placeholder(),
    const OrderScreen(),
  ];

  void _onItemTapped(int index) {
    if (_currentIndex == 1 && index != 1) {
      context.read<ProductBloc>().add(const ResetProductsEvent());
    }
    setState(() {
      _currentIndex = index;
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