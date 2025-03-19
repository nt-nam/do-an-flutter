import '../entities/order.dart' as entity;
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart' as model;

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<List<entity.Order>> call(int accountId, {int page = 1, int limit = 10}) async {
    try {
      final orderModels = await repository.getOrdersByAccount(accountId);
      return orderModels.map((modelOrder) => entity.Order(
        id: modelOrder.maDH,
        accountId: modelOrder.maTK,
        cartId: modelOrder.maGH,
        orderDate: modelOrder.ngayDat,
        totalAmount: modelOrder.tongTien,
        status: _mapOrderStatus(modelOrder.trangThai),
        deliveryAddress: modelOrder.diaChiGiao,
        offerId: modelOrder.maUD,
      )).toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  entity.OrderStatus _mapOrderStatus(model.OrderStatus status) {
    switch (status) {
      case model.OrderStatus.pending:
        return entity.OrderStatus.pending;
      case model.OrderStatus.delivering:
        return entity.OrderStatus.delivering;
      case model.OrderStatus.delivered:
        return entity.OrderStatus.delivered;
      case model.OrderStatus.cancelled:
        return entity.OrderStatus.cancelled;
    }
  }
}