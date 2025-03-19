import '../entities/order.dart' as entity;
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart' as model;

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

  model.OrderStatus _mapToModelOrderStatus(entity.OrderStatus status) {
    switch (status) {
      case entity.OrderStatus.pending:
        return model.OrderStatus.pending;
      case entity.OrderStatus.delivering:
        return model.OrderStatus.delivering;
      case entity.OrderStatus.delivered:
        return model.OrderStatus.delivered;
      case entity.OrderStatus.cancelled:
        return model.OrderStatus.cancelled;
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