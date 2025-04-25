import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/order/order_bloc.dart';
import '../../../../domain/usecases/user/update_user_level_usecase.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Hồ sơ cá nhân', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Xử lý khi nhấn vào nút cài đặt
            },
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          if (accountState is AccountLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            );
          } else if (accountState is AccountLoggedIn) {
            final accountId = accountState.account.id;
            // Chỉ gửi LoadUserByAccountId nếu chưa có dữ liệu
            if (!(context.read<UserBloc>().state is UserLoaded)) {
              context.read<UserBloc>().add(LoadUserByAccountId(accountId));
            }

            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  );
                } else if (userState is UserLoaded) {
                  final user = userState.user;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildInfoSection(user),
                          const SizedBox(height: 24),
                          _buildEditButton(context, user),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                } else if (userState is UserError) {
                  return Center(child: Text('Lỗi: ${userState.message}'));
                }
                return const Center(child: Text('Không có dữ liệu người dùng.'));
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Vui lòng đăng nhập để xem hồ sơ!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoSection(dynamic user) {
    String userLevelText = 'Khách hàng cấp 1';
    Color levelColor = Colors.teal;
    
    // Xác định văn bản và màu sắc dựa trên cấp độ
    if (user.level != null) {
      switch (user.level) {
        case 1:
          userLevelText = 'Khách hàng cấp 1';
          levelColor = Colors.teal;
          break;
        case 2:
          userLevelText = 'Khách hàng cấp 2';
          levelColor = Colors.deepPurple;
          break;
        case 3:
          userLevelText = 'Khách hàng cấp 3 - Cao cấp';
          levelColor = Colors.deepOrange;
          break;
        default:
          userLevelText = 'Khách hàng cấp 1';
          levelColor = Colors.teal;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.teal, size: 24),
                const SizedBox(width: 12),
                Text(
                  user.fullName ?? 'Chưa cập nhật',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            _buildProfileField('Số điện thoại', user.phoneNumber ?? 'Chưa cập nhật', Icons.phone_outlined),
            const SizedBox(height: 16),
            _buildProfileField('Địa chỉ', user.address ?? 'Chưa cập nhật', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildProfileField('Email', user.email ?? 'Chưa cập nhật', Icons.email_outlined),
            const SizedBox(height: 16),
            _buildUserLevelField(userLevelText, levelColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value, IconData iconData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(iconData, color: Colors.teal.shade300, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserLevelField(String levelText, Color levelColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.stars, color: levelColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cấp độ thành viên',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                levelText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: levelColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context, dynamic user) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit_outlined, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Chỉnh sửa hồ sơ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Thêm nút cập nhật cấp độ thủ công
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              try {
                developer.log('🔄 Đang cập nhật thủ công cấp độ người dùng...');
                final accountState = context.read<AccountBloc>().state;
                if (accountState is AccountLoggedIn) {
                  // Lấy các repository từ context
                  final userRepository = context.read<UserBloc>().userRepository;
                  
                  // Hiển thị dialog thông báo đang cập nhật
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const AlertDialog(
                      title: Text('Đang cập nhật...'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Đang cập nhật cấp độ người dùng, vui lòng đợi...'),
                        ],
                      ),
                    ),
                  );
                  
                  // Sử dụng OrderBloc để cập nhật cấp độ
                  final orderBloc = context.read<OrderBloc>();
                  if (orderBloc.updateUserLevelUseCase != null) {
                    final result = await orderBloc.updateUserLevelUseCase!(accountState.account.id);
                    developer.log('🔄 Kết quả cập nhật: CapDo=${result.capDo}');
                    
                    // Đóng dialog
                    Navigator.of(context).pop();
                    
                    // Hiển thị thông báo thành công
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật cấp độ thành công!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    
                    // Làm mới thông tin người dùng
                    context.read<UserBloc>().add(LoadUserByAccountId(accountState.account.id));
                  } else {
                    developer.log('🔄 Không tìm thấy UpdateUserLevelUseCase');
                    // Đóng dialog
                    Navigator.of(context).pop();
                    
                    // Hiển thị thông báo lỗi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Không thể cập nhật cấp độ: Không tìm thấy dịch vụ cập nhật'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                developer.log('🔄 Lỗi khi cập nhật thủ công: $e', error: e);
                // Đóng dialog nếu đang hiển thị
                Navigator.of(context, rootNavigator: true).pop();
                
                // Hiển thị thông báo lỗi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Cập nhật cấp độ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}