import '../../entities/order.dart' as entity;
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';
import '../../../data/models/order_model.dart' as model;

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<entity.Order> call(int orderId, entity.OrderStatus newStatus) async {
    try {
      final existingOrder = (await repository.getOrders()).firstWhere((o) => o.maDH == orderId);
      final updatedOrderModel = model.OrderModel(
        maDH: orderId,
        maTK: existingOrder.maTK,
        maGH: existingOrder.maGH,
        ngayDat: existingOrder.ngayDat,
        tongTien: existingOrder.tongTien,
        trangThai: _mapToModelOrderStatus(newStatus),
        diaChiGiao: existingOrder.diaChiGiao,
        maUD: existingOrder.maUD,
      );
      final result = await repository.updateOrder(updatedOrderModel);
      return entity.Order(
        id: result.maDH,
        accountId: result.maTK,
        cartId: result.maGH,
        orderDate: result.ngayDat,
        totalAmount: result.tongTien,
        status: _mapOrderStatus(result.trangThai),
        deliveryAddress: result.diaChiGiao,
        offerId: result.maUD,
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  OrderStatus _mapToModelOrderStatus(entity.OrderStatus status) {
    switch (status) {
      case entity.OrderStatus.pending:
        return OrderStatus.pending;
      case entity.OrderStatus.delivering:
        return OrderStatus.delivering;
      case entity.OrderStatus.delivered:
        return OrderStatus.delivered;
      case entity.OrderStatus.cancelled:
        return OrderStatus.cancelled;
    }
  }

  entity.OrderStatus _mapOrderStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return entity.OrderStatus.pending;
      case OrderStatus.delivering:
        return entity.OrderStatus.delivering;
      case OrderStatus.delivered:
        return entity.OrderStatus.delivered;
      case OrderStatus.cancelled:
        return entity.OrderStatus.cancelled;
    }
  }
}