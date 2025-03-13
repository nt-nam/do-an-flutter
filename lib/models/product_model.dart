// lib/models/product_model.dart
class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String status;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.status,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['MaSP'],
      name: json['TenSP'],
      description: json['MoTa'],
      price: json['Gia'].toDouble(),
      quantity: json['SoLuong'],
      status: json['TrangThai'],
      imageUrl: json['HinhAnh'],
    );
  }
}