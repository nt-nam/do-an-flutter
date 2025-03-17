import '../entities/offer.dart';
import '../repositories/offer_repository.dart';
import '../../data/models/offer_model.dart';

class GetOffersUseCase {
  final OfferRepository repository;

  GetOffersUseCase(this.repository);

  Future<List<Offer>> call({bool onlyActive = false}) async {
    try {
      final offerModels = await repository.getOffers();
      var filteredOffers = offerModels;
      if (onlyActive) {
        filteredOffers = offerModels.where((model) => model.trangThai == 'Hoạt động').toList();
      }
      return filteredOffers.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get offers: $e');
    }
  }

  Offer _mapToEntity(OfferModel model) {
    return Offer(
      id: model.maUD,
      name: model.tenUD,
      discountAmount: model.mucGiam,
      startDate: model.ngayBatDau,
      endDate: model.ngayKetThuc,
      status: model.trangThai,
    );
  }
}