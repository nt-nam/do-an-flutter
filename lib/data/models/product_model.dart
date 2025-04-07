import 'dart:io';
import '../../domain/entities/product.dart';
import '../services/api_service.dart';

class ProductModel {
  final int id;         // Changed from maSP
  final String name;    // Changed from tenSP
  final String? description; // Changed from moTa
  final double price;   // Changed from gia
  final int categoryId; // Changed from maLoai
  final String? imageUrl; // Changed from hinhAnh
  final String status;  // Changed from trangThai
  final int stock;      // Changed from soLuongTon

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    required this.status,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['MaSP'] is String ? int.tryParse(json['MaSP']) ?? 0 : json['MaSP'] as int,
      name: json['TenSP'] as String,
      description: json['MoTa'] as String?,
      price: (json['Gia'] as num).toDouble(),
      categoryId: json['MaLoai'] is String ? int.tryParse(json['MaLoai']) ?? 0 : json['MaLoai'] as int,
      imageUrl: json['HinhAnh'] != null ? '${ApiService().getBaseUrl()}/${json['HinhAnh']}' : null,
      status: json['TrangThai'] as String,
      stock: json['SoLuongTon'] is String ? int.tryParse(json['SoLuongTon']) ?? 0 : json['SoLuongTon'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MaSP': id,
      'TenSP': name,
      'MoTa': description,
      'Gia': price,
      'MaLoai': categoryId,
      'HinhAnh': imageUrl,
      'TrangThai': status,
      'SoLuongTon': stock,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      stock: stock,
      status: status == 'Còn hàng' ? ProductStatus.inStock : ProductStatus.outOfStock,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }
}