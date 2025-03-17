import '../models/order_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService apiService;
  final AuthService authService;

  OrderRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<OrderModel>> getOrders() async {
    final token = await authService.getToken();
    final data = await apiService.get('donhang', token: token);
    return (data as List).map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final token = await authService.getToken();
    final data = await apiService.post('donhang', order.toJson(), token: token);
    return OrderModel.fromJson(data);
  }

  @override
  Future<OrderModel> updateOrder(OrderModel order) async {
    final token = await authService.getToken();
    final data = await apiService.put('donhang/${order.maDH}', order.toJson(), token: token);
    return OrderModel.fromJson(data);
  }

  @override
  Future<List<OrderModel>> getOrdersByAccount(int accountId) async {
    final token = await authService.getToken();
    final data = await apiService.get('donhang?MaTK=$accountId', token: token);
    return (data as List).map((json) => OrderModel.fromJson(json)).toList();
  }
}