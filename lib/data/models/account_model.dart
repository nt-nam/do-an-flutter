class AccountModel {
  final int maTK;
  final String email; // Không cần String? vì không bao giờ null
  final String matKhau; // Không cần String? vì không bao giờ null
  final String vaiTro; // ENUM: 'Khách hàng', 'Nhân viên', 'Quản trị'
  final bool trangThai;

  AccountModel({
    required this.maTK,
    required this.email,
    required this.matKhau,
    required this.vaiTro,
    required this.trangThai,
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
        return 'Khách hàng'; // Giá trị mặc định
    }
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      maTK: json['id'] as int? ?? 0, // Ánh xạ từ 'id'
      email: json['email'] as String? ?? '', // Đảm bảo không null
      matKhau: json['MatKhau'] as String? ?? '', // API không trả về MatKhau, cung cấp giá trị mặc định
      vaiTro: _mapVaiTro(json['role'] as int? ?? 1), // Chuyển đổi từ int sang String
      trangThai: (json['status'] as int? ?? 1) == 1, // Chuyển đổi từ int sang bool
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
}