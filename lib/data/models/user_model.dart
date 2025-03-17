class UserModel {
  final int maND;
  final int? maTK; // Có thể null nếu không liên kết tài khoản
  final String hoTen;
  final String sdt;
  final String diaChi;

  UserModel({
    required this.maND,
    this.maTK,
    required this.hoTen,
    required this.sdt,
    required this.diaChi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      maND: json['MaND'] as int,
      maTK: json['MaTK'] as int?,
      hoTen: json['HoTen'] as String,
      sdt: json['SDT'] as String,
      diaChi: json['DiaChi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaND': maND,
      'MaTK': maTK,
      'HoTen': hoTen,
      'SDT': sdt,
      'DiaChi': diaChi,
    };
  }
}