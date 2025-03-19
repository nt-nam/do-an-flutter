enum ProductStatus {
  inStock,
  outOfStock,
}

class Product {
  final int id;
  final String name;
  final String? description; // Có thể null
  final double price;
  final int? categoryId; // Có thể null
  final String? imageUrl; // Có thể null
  final ProductStatus status; // 'Còn hàng', 'Hết hàng'
  final int stock;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.categoryId,
    this.imageUrl,
    required this.status,
    required this.stock,
  });
}