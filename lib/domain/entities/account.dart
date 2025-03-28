class Account {
  final int id;
  final int? userId;
  final String email;
  final String password;
  final String role; // 'Khách hàng', 'Nhân viên', 'Quản trị'
  final bool isActive;

  Account({
    required this.id,
    this.userId,
    required this.email,
    required this.password,
    required this.role,
    required this.isActive,
  });
}