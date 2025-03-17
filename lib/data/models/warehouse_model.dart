class WarehouseModel {
  final int maKho;
  final String tenKho;
  final String diaChi;

  WarehouseModel({
    required this.maKho,
    required this.tenKho,
    required this.diaChi,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      maKho: json['MaKho'] as int,
      tenKho: json['TenKho'] as String,
      diaChi: json['DiaChi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaKho': maKho,
      'TenKho': tenKho,
      'DiaChi': diaChi,
    };
  }
}