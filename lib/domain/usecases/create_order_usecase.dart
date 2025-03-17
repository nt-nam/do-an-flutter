import '../entities/order.dart';
import '../entities/order_detail.dart';
import '../repositories/order_repository.dart';
import '../repositories/order_detail_repository.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_detail_model.dart';

class CreateOrderUseCase {
  final OrderRepository orderRepository;
  final OrderDetailRepository orderDetailRepository;

  CreateOrderUseCase(this.orderRepository, this.orderDetailRepository);

  Future<Order> call(
      int accountId,
      List<(int productId, int quantity, double price)> items,
      String deliveryAddress, {
        int? offerId,
      }) async {
    try {
      final totalAmount = items.fold<double>(0, (sum, item) => sum + item.$2 * item.$3);
      final orderModel = OrderModel(
        maDH: 0,
        maTK: accountId,
        ngayDat: DateTime.now(),
        tongTien: totalAmount,
        trangThai: 'Chờ xác nhận',
        diaChiGiao: deliveryAddress,
        maUD: offerId,
      );
      final createdOrder = await orderRepository.createOrder(orderModel);

      // Thêm chi tiết đơn hàng
      for (var item in items) {
        final detailModel = OrderDetailModel(
          maDH: createdOrder.maDH,
          maSP: item.$1,
          soLuong: item.$2,
          giaLucMua: item.$3,
        );
        await orderDetailRepository.createOrderDetail(detailModel);
      }

      return _mapToEntity(createdOrder);
    } catch (e) {
      throw Exception('Failed to create order: $e');
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