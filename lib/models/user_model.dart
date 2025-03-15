// lib/models/user_model.dart
class UserModel {
  final int id; // MaTK
  final String email; // Email
  final String role; // VaiTro: customer, delivery, admin
  final bool isActive; // TrangThai
  final String? fullName; // HoTen
  final String? phone; // SDT
  final String? address; // DiaChi

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    this.fullName,
    this.phone,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['MaTK'] ?? 0,
      email: json['Email'] ?? '',
      role: _mapRole(json['VaiTro'] ?? 1), // Mặc định VaiTro = 1 (customer)
      isActive: (json['TrangThai'] ?? 1) == 1, // Mặc định TrangThai = 1
      fullName: json['HoTen'],
      phone: json['SDT'],
      address: json['DiaChi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaTK': id,
      'Email': email,
      'VaiTro': _mapRoleToInt(role),
      'TrangThai': isActive ? 1 : 0,
      'HoTen': fullName,
      'SDT': phone,
      'DiaChi': address,
    };
  }

  static String _mapRole(int roleId) {
    switch (roleId) {
      case 1: return 'customer';
      case 2: return 'delivery';
      case 3: return 'admin';
      default: return 'customer'; // Mặc định là customer
    }
  }

  static int _mapRoleToInt(String role) {
    switch (role) {
      case 'customer': return 1;
      case 'delivery': return 2;
      case 'admin': return 3;
      default: return 1; // Mặc định là 1
    }
  }
}