import '../../entities/offer.dart';
import '../../repositories/offer_repository.dart';
import '../../../data/models/offer_model.dart';

class AddOfferUseCase {
  final OfferRepository repository;

  AddOfferUseCase(this.repository);

  Future<Offer> call(
      String name,
      double discountAmount,
      DateTime startDate,
      DateTime endDate,
      ) async {
    if (name.isEmpty) throw Exception('Offer name cannot be empty');
    if (discountAmount <= 0) throw Exception('Discount amount must be positive');
    if (endDate.isBefore(startDate)) throw Exception('End date must be after start date');

    try {
      final offerModel = OfferModel(
        maUD: 0,
        tenUD: name,
        mucGiam: discountAmount,
        ngayBatDau: startDate,
        ngayKetThuc: endDate,
        trangThai: endDate.isBefore(DateTime.now()) ? OfferStatus.expired : OfferStatus.active,
      );
      final result = await repository.createOffer(offerModel);
      return Offer(
        id: result.maUD,
        name: result.tenUD,
        discountAmount: result.mucGiam,
        startDate: result.ngayBatDau,
        endDate: result.ngayKetThuc,
        status: result.trangThai,
      );
    } catch (e) {
      throw Exception('Failed to add offer: $e');
    }
  }
}