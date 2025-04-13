import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas_store/presentation/pages/screens/profile/ChangeRoleScreen.dart';
import 'package:gas_store/presentation/pages/screens/profile/ProfileScreen.dart';
import '../../../presentation/pages/screens/product/AddProductScreen.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/account/account_event.dart';
import '../../blocs/account/account_state.dart';
import '../../blocs/offer/offer_bloc.dart';
import '../../blocs/offer/offer_event.dart';
import 'SettingScreen.dart';
import 'auth/LoginScreen.dart';
import 'offer/ListOfferScreen.dart';
import 'order/OrderManagerScreen.dart'; // Giả sử đường dẫn đúng

class MenuManagerScreen extends StatelessWidget {
  const MenuManagerScreen({super.key});

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              title: 'Thay đổi vai trò',
              onTap: () {
                final accountBloc = context.read<AccountBloc>();
                if (accountBloc.state is AccountLoggedIn &&
                    (accountBloc.state as AccountLoggedIn).account.role == 'Quản trị') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: accountBloc, // Giữ nguyên Bloc instance
                        child: const ChangeRoleScreen(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bạn không có quyền truy cập')),
                  );
                }
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.message_outlined,
              title: 'Tin nhắn',
              hasNotification: true,
              onTap: () {
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_shipping_outlined,
              title: 'Quản lý đơn hàng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderManagerScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.local_offer_outlined,
              title: 'Ưu đãi',
              onTap: () {
                context.read<OfferBloc>().add(const FetchOffersEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListOfferScreen()),
                );
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.star_outline,
              title: 'Đánh giá',
              onTap: () {
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.star_outline,
              title: 'Thêm sản phẩm',
              onTap: () {
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

void _showRoleManagementScreen(BuildContext context) {
  context.read<AccountBloc>().add(const FetchAllAccountsEvent());

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: context.read<AccountBloc>(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý tài khoản'),
          ),
          body: BlocConsumer<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is AccountRoleUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật vai trò thành công')),
                );
                context.read<AccountBloc>().add(const FetchAllAccountsEvent());
              }
            },
            builder: (context, state) {
              if (state is AllAccountsLoaded) {
                return ListView.builder(
                  itemCount: state.accounts.length,
                  itemBuilder: (context, index) {
                    final account = state.accounts[index];
                    return ListTile(
                      title: Text(account.email),
                      subtitle: Text('Vai trò: ${account.vaiTro}'),
                      trailing: account.vaiTro != 'Quản trị'
                          ? DropdownButton<String>(
                        value: account.vaiTro,
                        items: const [
                          DropdownMenuItem(
                            value: 'Khách hàng',
                            child: Text('Khách hàng'),
                          ),
                          DropdownMenuItem(
                            value: 'Nhân viên',
                            child: Text('Nhân viên'),
                          ),
                        ],
                        onChanged: (newRole) {
                          if (newRole != null) {
                            context.read<AccountBloc>().add(
                              UpdateAccountRoleEvent(account.maTK, newRole),
                            );
                          }
                        },
                      )
                          : const Text('Quản trị (không thể thay đổi)'),
                    );
                  },
                );
              } else if (state is AccountError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    ),
  );
}