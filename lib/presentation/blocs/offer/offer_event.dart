abstract class OfferEvent {
  const OfferEvent();
}

class FetchOffersEvent extends OfferEvent {
  final bool onlyActive;

  const FetchOffersEvent({this.onlyActive = false});
}

class AddOfferEvent extends OfferEvent {
  final String name;
  final double discountAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minBill;
  final String? productCode;
  final String? productType;
  final String? note;
  final int? maxUses;
  final int? customerLimit;
  final double? maxDiscount;

  const AddOfferEvent(
      this.name,
      this.discountAmount,
      this.startDate,
      this.endDate, {
        this.minBill,
        this.productCode,
        this.productType,
        this.note,
        this.maxUses,
        this.customerLimit,
        this.maxDiscount,
      });
}

class UpdateOfferEvent extends OfferEvent {
  final String offerId;
  final String name;
  final double discountAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;

  const UpdateOfferEvent(
      this.offerId,
      this.name,
      this.discountAmount,
      this.startDate,
      this.endDate,
      this.status,
      );
}

class DeleteOfferEvent extends OfferEvent {
  final String offerId;

  const DeleteOfferEvent(this.offerId);
}