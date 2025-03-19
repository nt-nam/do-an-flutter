enum DeliveryStatus {
  notDelivered,
  delivering,
  delivered,
}

class Delivery {
  final int id;
  final int? orderId; // Có thể null nếu đơn hàng bị xóa
  final int? staffId; // Có thể null nếu chưa có nhân viên giao
  final DateTime? deliveryDate; // Có thể null nếu chưa giao
  final DeliveryStatus status; // 'Chưa giao', 'Đang giao', 'Đã giao'

  Delivery({
    required this.id,
    this.orderId,
    this.staffId,
    this.deliveryDate,
    required this.status,
  });
}
