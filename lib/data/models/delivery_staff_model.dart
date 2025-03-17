class DeliveryStaffModel {
  final int maNVG;
  final String hoTen;
  final String sdt;
  final String diaChi;

  DeliveryStaffModel({
    required this.maNVG,
    required this.hoTen,
    required this.sdt,
    required this.diaChi,
  });

  factory DeliveryStaffModel.fromJson(Map<String, dynamic> json) {
    return DeliveryStaffModel(
      maNVG: json['MaNVG'] as int,
      hoTen: json['HoTen'] as String,
      sdt: json['SDT'] as String,
      diaChi: json['DiaChi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaNVG': maNVG,
      'HoTen': hoTen,
      'SDT': sdt,
      'DiaChi': diaChi,
    };
  }
}