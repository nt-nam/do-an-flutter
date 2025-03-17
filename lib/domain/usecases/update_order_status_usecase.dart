import '../entities/order.dart';
import '../repositories/order_repository.dart';
import '../../data/models/order_model.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  Future<Order> call(int orderId, String newStatus) async {
    try {
      if (newStatus.isEmpty) throw Exception('Status cannot be empty');
      // Giả định OrderModel cần đầy đủ thông tin để cập nhật
      final orderModel = OrderModel(
        maDH: orderId,
        maTK: 0, // Sẽ được API điền lại
        ngayDat: DateTime.now(), // Không cần cập nhật
        tongTien: 0, // Không cần cập nhật
        trangThai: newStatus,
        diaChiGiao: '', // Không cần cập nhật
        maUD: null, // Không cần cập nhật
      );
      final updatedOrder = await repository.updateOrder(orderModel);
      return Order(
        id: updatedOrder.maDH,
        accountId: updatedOrder.maTK,
        orderDate: updatedOrder.ngayDat,
        totalAmount: updatedOrder.tongTien,
        status: updatedOrder.trangThai,
        deliveryAddress: updatedOrder.diaChiGiao,
        offerId: updatedOrder.maUD,
      );
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}