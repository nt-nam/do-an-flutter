import '../models/order_detail_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/order_detail_repository.dart';

class OrderDetailRepositoryImpl implements OrderDetailRepository {
  final ApiService apiService;
  final AuthService authService;

  OrderDetailRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<OrderDetailModel>> getOrderDetails(int orderId) async {
    final token = await authService.getToken();
    final data = await apiService.get('chitietdonhang?MaDH=$orderId', token: token);
    return (data as List).map((json) => OrderDetailModel.fromJson(json)).toList();
  }

  @override
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel detailModel) async {
    final token = await authService.getToken();
    final data = await apiService.post('chitietdonhang', detailModel.toJson(), token: token);
    return OrderDetailModel.fromJson(data);
  }
}