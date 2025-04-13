import '../../../domain/entities/cart_detail.dart';
import '../../../domain/entities/order.dart' as entity;
import '../../../domain/repositories/cart_repository.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../../data/models/order_model.dart' as model;
import '../../../data/models/order_detail_model.dart';

class CreateOrderUseCase {
  final OrderRepository orderRepository;
  final CartRepository cartRepository;

  CreateOrderUseCase({
    required this.orderRepository,
    required this.cartRepository,
  });

  Future<entity.Order> call(
      int accountId,
      List<CartDetail> items,
      String deliveryAddress, {
        String? offerId,
        int? cartId,
        required double totalAmount,
      }) async {
    try {
      // 1. Tạo đơn hàng
      final orderModel = model.OrderModel(
        maDH: 0,
        maTK: accountId,
        // maGH: cartId,
        ngayDat: DateTime.now(),
        tongTien: totalAmount,
        trangThai: model.OrderStatus.pending,
        diaChiGiao: deliveryAddress,
        maUD: offerId,
      );
      final createdOrder = await orderRepository.createOrder(orderModel);

      // 2. Kiểm tra mã đơn hàng (maDH)
      if (createdOrder.maDH == null) {
        throw Exception('Failed to create order: Order ID (MaDH) is null');
      }
      final orderId = createdOrder.maDH!;

      // 3. Tạo chi tiết đơn hàng
      // for (var item in items) {
      //   if (item.productId == null || item.quantity == null) {
      //     await orderRepository.deleteOrder(orderId);
      //     throw Exception('Invalid cart item: productId or quantity is null');
      //   }
      //   final detailModel = OrderDetailModel(
      //     maDH: orderId,
      //     maSP: item.productId,
      //     soLuong: item.quantity,
      //     donGia: item.price ?? 10000,
      //   );
      //   final createdDetail = await orderRepository.createOrderDetail(detailModel);
      //   if (createdDetail.maCTDH == null) {
      //     await orderRepository.deleteOrder(orderId);
      //     throw Exception('Failed to create order detail for product ID ${item.productId}');
      //   }
      // }

      // 4. Xóa giỏ hàng sau khi tạo đơn hàng thành công
      // await cartRepository.clearCart(accountId);

      // 5. Trả về đơn hàng đã tạo
      return entity.Order(
        id: createdOrder.maDH,
        accountId: createdOrder.maTK,
        cartId: createdOrder.maGH,
        orderDate: createdOrder.ngayDat ?? DateTime.now(),
        totalAmount: createdOrder.tongTien ?? 0,
        status: _mapOrderStatus(createdOrder.trangThai),
        deliveryAddress: createdOrder.diaChiGiao,
        offerId: createdOrder.maUD,
      );
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  entity.OrderStatus _mapOrderStatus(model.OrderStatus? status) {
    switch (status) {
      case model.OrderStatus.pending:
        return entity.OrderStatus.pending;
      case model.OrderStatus.delivering:
        return entity.OrderStatus.delivering;
      case model.OrderStatus.delivered:
        return entity.OrderStatus.delivered;
      case model.OrderStatus.cancelled:
        return entity.OrderStatus.cancelled;
      default:
        return entity.OrderStatus.pending;
    }
  }
}