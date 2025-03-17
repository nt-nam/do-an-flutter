import '../entities/offer.dart';
import '../repositories/offer_repository.dart';
import '../../data/models/offer_model.dart';

class AddOfferUseCase {
  final OfferRepository repository;

  AddOfferUseCase(this.repository);

  Future<Offer> call(String name, double discountAmount, DateTime startDate, DateTime endDate) async {
    try {
      final offerModel = OfferModel(
        maUD: 0, // API sẽ sinh
        tenUD: name,
        mucGiam: discountAmount,
        ngayBatDau: startDate,
        ngayKetThuc: endDate,
        trangThai: 'Hoạt động', // Mặc định khi tạo
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