enum OfferStatus { active, inactive, expired }
enum DiscountType { amount, percentage }

class Offer {
  final String id;
  final String name;
  final double discountAmount;
  final DiscountType discountType;
  final DateTime? startDate;
  final DateTime? endDate;
  final OfferStatus status;
  final double? minBill; // Hóa đơn tối thiểu
  final String? productCode; // Mã sản phẩm
  final String? productType; // Loại sản phẩm
  final String? note; // Ghi chú
  final int? maxUses; // Số lần sử dụng tối đa
  final int? customerLimit; // Giới hạn mỗi khách
  final double? maxDiscount; // Giá trị giảm tối đa

  Offer({
    required this.id,
    required this.name,
    required this.discountAmount,
    required this.discountType,
    this.startDate,
    this.endDate,
    required this.status,
    this.minBill,
    this.productCode,
    this.productType,
    this.note,
    this.maxUses,
    this.customerLimit,
    this.maxDiscount,
  });
}