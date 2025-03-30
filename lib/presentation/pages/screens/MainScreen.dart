import 'package:flutter/material.dart';
import '../../widgets/CustomBottomNavigation.dart';
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

  // Danh sách các màn hình
  final List<Widget> _screens = [
    const HomeScreen(),
    FindProductScreen(),
    const Placeholder(), // Thay bằng CartScreen khi có
    const Placeholder(), // Thay bằng NotificationScreen khi có
    const OrderScreen(),
  ];

  void _onItemTapped(int index) {
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