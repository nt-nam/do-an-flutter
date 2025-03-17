import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getOrdersByAccount(int accountId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrder(OrderModel order);
}