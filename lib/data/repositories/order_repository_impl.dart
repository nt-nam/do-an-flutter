import '../models/order_detail_model.dart';
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
    // Kiểm tra nếu data là Map và lấy danh sách từ key "data"
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return (data['data'] as List).map((json) => OrderModel.fromJson(json)).toList();
    }
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
    // Kiểm tra nếu data là Map và lấy danh sách từ key "data"
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return (data['data'] as List).map((json) => OrderModel.fromJson(json)).toList();
    }
    return (data as List).map((json) => OrderModel.fromJson(json)).toList();
  }

  @override
  Future<List<OrderDetailModel>> getOrderDetails(int orderId) async {
    final token = await authService.getToken();
    final data = await apiService.get('chitietdonhang?MaDH=$orderId', token: token);
    // Kiểm tra nếu data là Map và lấy danh sách từ key "data"
    if (data is Map<String, dynamic> && data.containsKey('data')) {
      return (data['data'] as List).map((json) => OrderDetailModel.fromJson(json)).toList();
    }
    return (data as List).map((json) => OrderDetailModel.fromJson(json)).toList();
  }

  @override
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel detailModel) async {
    final token = await authService.getToken();
    final data = await apiService.post('chitietdonhang', detailModel.toJson(), token: token);
    return OrderDetailModel.fromJson(data);
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    final token = await authService.getToken();
    final data = await apiService.get('donhang/$orderId', token: token);
    return OrderModel.fromJson(data);
  }
}