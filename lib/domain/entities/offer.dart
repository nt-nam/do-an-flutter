class Offer {
  final int id;
  final String name;
  final double discountAmount; // % hoặc số tiền giảm
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'Hoạt động', 'Hết hạn'

  Offer({
    required this.id,
    required this.name,
    required this.discountAmount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}