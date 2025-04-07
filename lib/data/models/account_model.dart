import 'package:gas_store/data/models/user_model.dart';

class AccountModel {
  final int maTK;
  final String email;
  final String matKhau;
  final String vaiTro; // ENUM: 'Khách hàng', 'Nhân viên', 'Quản trị'
  final bool trangThai;
  final UserModel? user;

  AccountModel({
    required this.maTK,
    required this.email,
    required this.matKhau,
    required this.vaiTro,
    required this.trangThai,
    this.user,
  });

  // Hàm chuyển đổi VaiTro từ int sang String
  static String _mapVaiTro(int vaiTro) {
    switch (vaiTro) {
      case 1:
        return 'Khách hàng';
      case 2:
        return 'Nhân viên';
      case 3:
        return 'Quản trị';
      default:
        return 'Khách hàng';
    }
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      maTK: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      matKhau: json['MatKhau'] as String? ?? '',
      vaiTro: _mapVaiTro(json['role'] as int? ?? 1),
      trangThai: (json['status'] as int? ?? 1) == 1,
    );
  }

  factory AccountModel.fromApiResponse(Map<String, dynamic> json) {
    return AccountModel(
      maTK: json['maTK'] as int,
      email: json['email'] as String,
      matKhau: '',
      vaiTro: _mapVaiTro(json['vaiTro'] as int),
      trangThai: json['trangThai'] == 1,
      user: json['hoTen'] != null
          ? UserModel(
              maND: 0,
              maTK: json['maTK'],
              hoTen: json['hoTen'],
              sdt: '',
              diaChi: '',
              email: '',
            )
          : null,
    );
  }

  factory AccountModel.fromUserApiResponse(Map<String, dynamic> json) {
    return AccountModel(
      maTK: json['MaTK'] as int,
      email: json['Email'] as String,
      matKhau: '',
      // Không lấy mật khẩu
      vaiTro: _mapVaiTro(json['VaiTro'] as int),
      trangThai: json['TrangThai'] == 1,
      user: UserModel(
        maND: json['MaND'] ?? 0,
        maTK: json['MaTK'],
        hoTen: json['HoTen'] ?? '',
        sdt: json['SDT'] ?? '',
        diaChi: json['DiaChi'] ?? '',
        email: '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    // Chuyển đổi VaiTro từ String sang int khi gửi lên API
    int vaiTroInt;
    switch (vaiTro) {
      case 'Khách hàng':
        vaiTroInt = 1;
        break;
      case 'Nhân viên':
        vaiTroInt = 2;
        break;
      case 'Quản trị':
        vaiTroInt = 3;
        break;
      default:
        vaiTroInt = 1;
    }

    return {
      'MaTK': maTK,
      'Email': email,
      'MatKhau': matKhau,
      'VaiTro': vaiTroInt,
      'TrangThai': trangThai ? 1 : 0,
    };
  }

  Map<String, dynamic> toUpdateRoleJson() {
    return {
      'maTK': maTK,
      'vaiTro': vaiTro == 'Khách hàng' ? 1 : 2,
    };
  }

  static int _getRoleValue(String vaiTro) {
    switch (vaiTro) {
      case 'Khách hàng':
        return 1;
      case 'Nhân viên':
        return 2;
      case 'Quản trị':
        return 3;
      default:
        return 1;
    }
  }
}
