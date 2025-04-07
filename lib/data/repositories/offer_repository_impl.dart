import '../models/offer_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/offer_repository.dart';

class OfferRepositoryImpl implements OfferRepository {
  final ApiService apiService;
  final AuthService authService;

  OfferRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<OfferModel>> getOffers() async {
    try {
      final token = await authService.getToken();
      print('Token: $token'); // Kiểm tra token
      final data = await apiService.get('uudai.php', token: token);
      print('API Response: $data'); // Kiểm tra dữ liệu trả về
      return (data as List).map((json) => OfferModel.fromJson(json)).toList();
    } catch (e) {
      print('Error in getOffers: $e'); // In lỗi cụ thể
      throw Exception('Failed to load offers: $e');
    }
  }

  @override
  Future<OfferModel> createOffer(OfferModel offer) async {
    final token = await authService.getToken();
    final data = await apiService.post('uudai', offer.toJson(), token: token);
    return OfferModel.fromJson(data);
  }

  @override
  Future<OfferModel> updateOffer(OfferModel offer) async {
    final token = await authService.getToken();
    final data = await apiService.put('uudai/${offer.maUD}', offer.toJson(), token: token);
    return OfferModel.fromJson(data);
  }
}