class UserModel {
  final int maND;
  final int maTK; // Không nullable vì MaTK là bắt forced trong cơ sở dữ liệu
  final String hoTen;
  final String? sdt;
  final String? diaChi;
  final String email; // Thêm trường email từ bảng taikhoan

  UserModel({
    required this.maND,
    required this.maTK,
    required this.hoTen,
    this.sdt,
    this.diaChi,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      maND: int.parse(json['MaND'].toString()),
      maTK: int.parse(json['MaTK'].toString()),
      hoTen: json['HoTen'] as String,
      sdt: json['SDT'] as String?,
      diaChi: json['DiaChi'] as String?,
      email: json['Email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaND': maND,
      'MaTK': maTK,
      'HoTen': hoTen,
      'SDT': sdt,
      'DiaChi': diaChi,
      'Email': email,
    };
  }
}