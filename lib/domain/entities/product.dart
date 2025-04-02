enum ProductStatus {
  inStock,
  outOfStock,
}

class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int categoryId;
  final String? imageUrl;
  final ProductStatus status; // 'Còn hàng', 'Hết hàng'
  final int stock;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.categoryId,
    this.imageUrl,
    required this.status,
    required this.stock,
  });
}