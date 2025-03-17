class CategoryModel {
  final int maLoai;
  final String tenLoai;

  CategoryModel({
    required this.maLoai,
    required this.tenLoai,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      maLoai: json['MaLoai'] as int,
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