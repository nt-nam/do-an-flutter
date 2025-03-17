class Order {
  final int id;
  final int? accountId; // Có thể null nếu tài khoản bị xóa
  final DateTime orderDate;
  final double totalAmount;
  final String status; // 'Chờ xác nhận', 'Đang giao', 'Đã giao', 'Đã hủy'
  final String deliveryAddress;
  final int? offerId; // Có thể null nếu không có ưu đãi

  Order({
    required this.id,
    this.accountId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.deliveryAddress,
    this.offerId,
  });
}