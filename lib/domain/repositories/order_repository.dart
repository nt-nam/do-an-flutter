import '../../data/models/order_detail_model.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getOrdersByAccount(int accountId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
  Future<OrderModel> getOrderById(int orderId);
  Future<void> deleteOrder(int orderId);
  Future<List<OrderDetailModel>> getOrderDetails(int orderId);
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel detailModel);
}