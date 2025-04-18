import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/account/account_bloc.dart';
import '../../../blocs/account/account_state.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProfileField('Họ tên', user.fullName ?? 'Chưa cập nhật'),
                        _buildProfileField('Số điện thoại', user.phoneNumber ?? 'Chưa cập nhật'),
                        _buildProfileField('Địa chỉ', user.address ?? 'Chưa cập nhật'),
                        _buildProfileField('Email', user.email ?? 'Chưa cập nhật'),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(user: user),
                                ),
                              );
                              // Không cần làm mới thủ công, vì UserBloc sẽ phát ra trạng thái UserLoaded
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Chỉnh sửa hồ sơ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
              child: Text('Vui lòng đăng nhập để xem hồ sơ!'),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}