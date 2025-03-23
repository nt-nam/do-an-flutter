class Cart {
  final int id;
  final int? accountId;
  final DateTime addedDate;
  final String status; // 'Đang hoạt động', 'Đã thanh toán'

  Cart({
    required this.id,
    this.accountId,
    required this.addedDate,
    required this.status,
  });
}