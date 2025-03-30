import '../../entities/order.dart' as entity;
import '../../entities/cart_detail.dart';
import '../../repositories/order_repository.dart';
import '../../../data/models/order_model.dart' as model;
import '../../../data/models/order_detail_model.dart';

class CreateOrderUseCase {
  final OrderRepository orderRepository;

  CreateOrderUseCase(this.orderRepository);

  Future<entity.Order> call(
      int accountId,
      List<CartDetail> items,
      String deliveryAddress, {
        int? offerId,
        int? cartId,
      }) async {
    try {
      final orderModel = model.OrderModel(
        maDH: 0,
        maTK: accountId,
        maGH: cartId,
        ngayDat: DateTime.now(),
        tongTien: items.fold(0, (sum, item) => sum + (item.price ?? 0) * item.quantity),
        trangThai: model.OrderStatus.pending,
        diaChiGiao: deliveryAddress,
        maUD: offerId,
      );
      final createdOrder = await orderRepository.createOrder(orderModel);

      // Tạo chi tiết đơn hàng
      for (var item in items) {
        final detailModel = OrderDetailModel(
          maCTDH: 0,
          maDH: createdOrder.maDH ?? 0, // Xử lý null
          maSP: item.productId,
          soLuong: item.quantity,
          giaLucMua: item.price ?? 10000,
        );
        await orderRepository.createOrderDetail(detailModel);
      }

      return entity.Order(
        id: createdOrder.maDH,
        accountId: createdOrder.maTK,
        cartId: createdOrder.maGH,
        orderDate: createdOrder.ngayDat,
        totalAmount: createdOrder.tongTien,
        status: _mapOrderStatus(createdOrder.trangThai),
        deliveryAddress: createdOrder.diaChiGiao,
        offerId: createdOrder.maUD,
      );
    } catch (e) {
      throw Exception('Failed to create order: $e');
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