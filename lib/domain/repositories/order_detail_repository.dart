import '../../data/models/order_detail_model.dart';

abstract class OrderDetailRepository {
  Future<List<OrderDetailModel>> getOrderDetails(int orderId);
  Future<OrderDetailModel> createOrderDetail(OrderDetailModel detailModel);
}