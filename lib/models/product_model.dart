// lib/models/product_model.dart
class ProductModel {
  final int id; // MaSP
  final String name; // TenSP
  final String description; // MoTa
  final double price; // Gia
  final int quantity; // SoLuong
  final String status; // TrangThai
  final String? imageUrl; // URL hình ảnh (nullable)

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

  Map<String, dynamic> toJson() {
    return {
      'MaSP': id,
      'TenSP': name,
      'MoTa': description,
      'Gia': price,
      'SoLuong': quantity,
      'TrangThai': status,
      'HinhAnh': imageUrl,
    };
  }
}