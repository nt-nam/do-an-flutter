import '../../../domain/entities/offer.dart';

abstract class OfferState {
  const OfferState();
}

class OfferInitial extends OfferState {
  const OfferInitial();
}

class OfferLoading extends OfferState {
  const OfferLoading();
}

class OfferLoaded extends OfferState {
  final List<Offer> offers;

  const OfferLoaded(this.offers);
}

class OfferAdded extends OfferState {
  final Offer offer;

  const OfferAdded(this.offer);
}

class OfferUpdated extends OfferState {
  final Offer offer;

  const OfferUpdated(this.offer);
}

class OfferDeleted extends OfferState {
  final String offerId;

  const OfferDeleted(this.offerId);
}

class OfferError extends OfferState {
  final String message;

  const OfferError(this.message);
}