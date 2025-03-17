import '../models/delivery_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/delivery_repository.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final ApiService apiService;
  final AuthService authService;

  DeliveryRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<DeliveryModel>> getDeliveries() async {
    final token = await authService.getToken();
    final data = await apiService.get('vanchuyen', token: token);
    return (data as List).map((json) => DeliveryModel.fromJson(json)).toList();
  }

  @override
  Future<DeliveryModel> getDeliveryByOrderId(int orderId) async {
    final token = await authService.getToken();
    final data = await apiService.get('vanchuyen?MaDH=$orderId', token: token);
    return DeliveryModel.fromJson(data);
  }

  @override
  Future<DeliveryModel> updateDelivery(DeliveryModel delivery) async {
    final token = await authService.getToken();
    final data = await apiService.put('vanchuyen/${delivery.maVC}', delivery.toJson(), token: token);
    return DeliveryModel.fromJson(data);
  }
}