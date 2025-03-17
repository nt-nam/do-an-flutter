class Product {
  final int id;
  final String name;
  final String? description; // Có thể null
  final double price;
  final int? categoryId; // Có thể null
  final String? imageUrl; // Có thể null
  final String status; // 'Còn hàng', 'Hết hàng'

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.categoryId,
    this.imageUrl,
    required this.status,
  });
}