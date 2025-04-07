// lib/domain/entities/product.dart
enum ProductStatus { inStock, outOfStock }

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final ProductStatus status;
  final String? imageUrl;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.status,
    this.imageUrl,
    this.categoryId,
  });
}