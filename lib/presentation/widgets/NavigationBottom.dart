import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Danh sách các item với icon line và filled tương ứng
  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Trang chủ',
      lineIcon: Icons.home_outlined,
      filledIcon: Icons.home,
    ),
    _NavItem(
      label: 'Tìm kiếm',
      lineIcon: Icons.search_outlined,
      filledIcon: Icons.search,
    ),
    _NavItem(
      label: 'Giỏ hàng',
      lineIcon: Icons.shopping_cart_outlined,
      filledIcon: Icons.shopping_cart,
    ),
    _NavItem(
      label: 'Thông báo',
      lineIcon: Icons.notifications_outlined,
      filledIcon: Icons.notifications,
    ),
    _NavItem(
      label: 'Hóa đơn',
      lineIcon: Icons.receipt_long_outlined,
      filledIcon: Icons.receipt_long,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: onTap,
            items: _items.map((item) {
              return BottomNavigationBarItem(
                icon: Icon(
                  currentIndex == _items.indexOf(item)
                      ? item.filledIcon
                      : item.lineIcon,
                  size: 30,
                ),
                label: item.label,
              );
            }).toList(),
          ),
          // Nút giỏ hàng nổi ở giữa (giữ nguyên từ HomeScreen)
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal.shade900,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  currentIndex == 2
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Class phụ để lưu thông tin của từng item
class _NavItem {
  final String label;
  final IconData lineIcon;
  final IconData filledIcon;

  const _NavItem({
    required this.label,
    required this.lineIcon,
    required this.filledIcon,
  });
}