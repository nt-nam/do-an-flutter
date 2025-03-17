class Import {
  final int id;
  final int? productId; // Có thể null nếu sản phẩm bị xóa
  final int? warehouseId; // Có thể null nếu kho bị xóa
  final int quantity;
  final DateTime importDate;

  Import({
    required this.id,
    this.productId,
    this.warehouseId,
    required this.quantity,
    required this.importDate,
  });
}