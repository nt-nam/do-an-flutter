class AccountModel {
  final int maTK;
  final String email;
  final String matKhau;
  final String vaiTro; // ENUM: 'Khách hàng', 'Nhân viên', 'Quản trị'
  final bool trangThai;

  AccountModel({
    required this.maTK,
    required this.email,
    required this.matKhau,
    required this.vaiTro,
    required this.trangThai,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      maTK: json['MaTK'] as int,
      email: json['Email'] as String,
      matKhau: json['MatKhau'] as String,
      vaiTro: json['VaiTro'] as String,
      trangThai: json['TrangThai'] == 1 || json['TrangThai'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaTK': maTK,
      'Email': email,
      'MatKhau': matKhau,
      'VaiTro': vaiTro,
      'TrangThai': trangThai ? 1 : 0,
    };
  }
}