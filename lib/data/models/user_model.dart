class UserModel {
  final int maND;
  final int maTK;
  final String? hoTen; // Thay đổi từ String thành String?
  final String? sdt;
  final String? diaChi;
  final String? email;

  UserModel({
    required this.maND,
    required this.maTK,
    this.hoTen, // Xóa required
    this.sdt,
    this.diaChi,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['MaND'] == null || json['MaND'] <= 0) {
      throw Exception('API response thiếu hoặc MaND không hợp lệ: ${json['MaND']}');
    }
    if (json['MaTK'] == null || json['MaTK'] <= 0) {
      throw Exception('API response thiếu hoặc MaTK không hợp lệ: ${json['MaTK']}');
    }

    return UserModel(
      maND: json['MaND'],
      maTK: json['MaTK'],
      hoTen: json['HoTen'] ?? 'Không xác định', // Gán giá trị mặc định nếu null
      sdt: json['SDT'],
      diaChi: json['DiaChi'],
      email: json['Email'],
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