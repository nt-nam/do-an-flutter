import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/account_model.dart';
import '../../../../presentation/blocs/account/account_bloc.dart';
import '../../../../presentation/blocs/account/account_event.dart';
import '../../../../presentation/blocs/account/account_state.dart';
import '../auth/LoginScreen.dart';

class ChangeRoleScreen extends StatefulWidget {
  const ChangeRoleScreen({super.key});

  @override
  _ChangeRoleScreenState createState() => _ChangeRoleScreenState();
}

class _ChangeRoleScreenState extends State<ChangeRoleScreen> {
  final Map<int, String> _selectedRoles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountBloc>().add(const FetchAllAccountsEvent());
    });
  }

  void _showConfirmationDialog(BuildContext context, AccountModel account,
      String newRole) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận thay đổi'),
          content: Text('Bạn có chắc muốn đổi vai trò của ${account
              .email} thành "$newRole"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AccountBloc>().add(
                  UpdateAccountRoleEvent(account.maTK, newRole),
                );
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountError && state.message.contains('Unauthorized')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng đăng nhập lại')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý quyền'),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          body: BlocConsumer<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is AccountError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is AccountRoleUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật vai trò thành công')),
                );
                context.read<AccountBloc>().add(const FetchAllAccountsEvent());
              }
            },
            builder: (context, state) {
              if (state is AllAccountsLoaded) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.accounts.length,
                  itemBuilder: (context, index) {
                    final account = state.accounts[index];
                    _selectedRoles.putIfAbsent(
                        account.maTK, () => account.vaiTro);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text('Vai trò: '),
                                const SizedBox(width: 8),
                                account.vaiTro == 'Quản trị'
                                    ? Text(
                                  'Quản trị (không thể thay đổi)',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                                    : Expanded(
                                  child: DropdownButton<String>(
                                    value: _selectedRoles[account.maTK],
                                    isExpanded: true,
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
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedRoles[account.maTK] =
                                              newValue;
                                        });
                                        _showConfirmationDialog(
                                          context,
                                          account,
                                          newValue,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AccountError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
          ,
        )
    );
  }
}