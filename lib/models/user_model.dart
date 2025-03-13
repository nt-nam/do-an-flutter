// lib/models/user_model.dart
class UserModel {
  final int id;
  final String email;
  final String role; // customer, delivery, admin
  final bool isActive;
  final String? fullName;
  final String? phone;
  final String? address;

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
      id: json['MaTK'],
      email: json['Email'],
      role: _mapRole(json['VaiTro']),
      isActive: json['TrangThai'] == 1,
      fullName: json['HoTen'],
      phone: json['SDT'],
      address: json['DiaChi'],
    );
  }

  static String _mapRole(int roleId) {
    switch (roleId) {
      case 1: return 'customer';
      case 2: return 'delivery';
      case 3: return 'admin';
      default: return 'unknown';
    }
  }
}