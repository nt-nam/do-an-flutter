import '../../data/models/offer_model.dart';

abstract class OfferRepository {
  Future<List<OfferModel>> getOffers();
  Future<OfferModel> createOffer(OfferModel offer);
  Future<OfferModel> updateOffer(OfferModel offer);
}