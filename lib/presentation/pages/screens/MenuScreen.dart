import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/pages/screens/product/AddProductScreen.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_event.dart';
import 'SettingScreen.dart';
import 'auth/LoginScreen.dart'; // Giả sử đường dẫn đúng

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context), // Quay lại HomeScreen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Hồ sơ',
              onTap: () {
                // TODO: Chuyển sang trang Hồ sơ
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.message_outlined,
              title: 'Tin nhắn',
              hasNotification: false, // Box báo hiệu mặc định ẩn
              onTap: () {
                // TODO: Chuyển sang trang Tin nhắn
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'Đang giao',
              onTap: () {
                // TODO: Chuyển sang trang Đang giao
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.check_circle_outline,
              title: 'Đã giao',
              onTap: () {
                // TODO: Chuyển sang trang Đã giao
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_offer_outlined,
              title: 'Ưu đãi',
              onTap: () {
                // TODO: Chuyển sang trang Ưu đãi
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.star_outline,
              title: 'Đánh giá',
              onTap: () {
                // TODO: Chuyển sang trang Đánh giá
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.star_outline,
              title: 'Thêm sản phẩm',
              onTap: () {
                // TODO: Chuyển sang trang Thêm sản phẩm
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Cài đặt',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.logout,
              title: 'Đăng xuất',
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        bool hasNotification = false, // Mặc định không có báo hiệu
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: hasNotification
            ? Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: onTap,
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context.read<AccountBloc>().add(const LogoutEvent());
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false, // Xóa hết stack để không quay lại
                );
              },
              child: const Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}