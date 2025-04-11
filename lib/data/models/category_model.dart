class CategoryModel {
  final int maLoai;
  final String tenLoai;

  CategoryModel({required this.maLoai, required this.tenLoai});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      maLoai: int.tryParse(json['MaLoai'].toString()) ?? 0,
      tenLoai: json['TenLoai'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaLoai': maLoai,
      'TenLoai': tenLoai,
    };
  }
}