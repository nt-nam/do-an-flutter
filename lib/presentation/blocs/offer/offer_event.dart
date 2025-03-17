abstract class OfferEvent {
  const OfferEvent();
}

class FetchOffersEvent extends OfferEvent {
  final bool onlyActive; // Lọc ưu đãi đang hoạt động

  const FetchOffersEvent({this.onlyActive = false});
}

class AddOfferEvent extends OfferEvent {
  final String name;
  final double discountAmount;
  final DateTime startDate;
  final DateTime endDate;

  const AddOfferEvent(this.name, this.discountAmount, this.startDate, this.endDate);
}

class UpdateOfferEvent extends OfferEvent {
  final int offerId;
  final String name;
  final double discountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  const UpdateOfferEvent(this.offerId, this.name, this.discountAmount, this.startDate, this.endDate, this.status);
}

class DeleteOfferEvent extends OfferEvent {
  final int offerId;

  const DeleteOfferEvent(this.offerId);
}