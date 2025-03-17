import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<Order>> call(int? accountId, {String? status, int page = 1, int limit = 10}) async {
    try {
      if (accountId == null) {
        // Trường hợp null: trả về danh sách trống hoặc logic khác tùy yêu cầu
        return [];
      }
      final orderModels = await repository.getOrdersByAccount(accountId);
      var filteredOrders = orderModels;
      if (status != null) {
        filteredOrders = orderModels.where((model) => model.trangThai == status).toList();
      }
      return filteredOrders.map(_mapToEntity).toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  Order _mapToEntity(OrderModel model) {
    return Order(
      id: model.maDH,
      accountId: model.maTK,
      orderDate: model.ngayDat,
      totalAmount: model.tongTien,
      status: model.trangThai,
      deliveryAddress: model.diaChiGiao,
      offerId: model.maUD,
    );
  }
}