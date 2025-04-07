import '../../entities/offer.dart';
import '../../repositories/offer_repository.dart';
import '../../../data/models/offer_model.dart';

class AddOfferUseCase {
  final OfferRepository repository;

  AddOfferUseCase(this.repository);

  Future<Offer> call(
      String name,
      double discountAmount,
      DateTime? startDate,
      DateTime? endDate, {
        double? minBill,
        String? productCode,
        String? productType,
        String? note,
        int? maxUses,
        int? customerLimit,
        double? maxDiscount,
      }) async {
    if (name.isEmpty) throw Exception('Offer name cannot be empty');
    if (discountAmount == 0) throw Exception('Discount amount must be non-zero');

    try {
      final discountType =
      discountAmount < 0 ? DiscountType.amount : DiscountType.percentage;
      final offerModel = OfferModel(
        maUD: DateTime.now().millisecondsSinceEpoch.toString(),
        tenUD: name,
        mucGiam: discountAmount,
        discountType: discountType,
        hoadonMin: minBill,
        masp: productCode,
        loaisp: productType,
        ngayBatDau: startDate,
        ngayKetThuc: endDate,
        trangThai: endDate != null && endDate.isBefore(DateTime.now())
            ? OfferStatus.expired
            : OfferStatus.active,
        ghiChu: note,
        soLanMax: maxUses,
        gioiHanKhach: customerLimit ?? 1,
        giaTriMax: maxDiscount,
      );
      final result = await repository.createOffer(offerModel);
      return Offer(
        id: result.maUD,
        name: result.tenUD,
        discountAmount: result.mucGiam,
        discountType: result.discountType,
        startDate: result.ngayBatDau,
        endDate: result.ngayKetThuc,
        status: result.trangThai,
        minBill: result.hoadonMin,
        productCode: result.masp,
        productType: result.loaisp,
        note: result.ghiChu,
        maxUses: result.soLanMax,
        customerLimit: result.gioiHanKhach,
        maxDiscount: result.giaTriMax,
      );
    } catch (e) {
      throw Exception('Failed to add offer: $e');
    }
  }
}