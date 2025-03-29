import '../../entities/order_detail.dart';
import '../../repositories/order_repository.dart';
import '../../../data/models/order_detail_model.dart';

class GetOrderDetailsUseCase {
  final OrderRepository repository;

  GetOrderDetailsUseCase(this.repository);

  Future<List<OrderDetail>> call(int orderId) async {
    try {
      final detailModels = await repository.getOrderDetails(orderId);
      return detailModels.map((model) => OrderDetail(
        id: model.maCTDH,
        orderId: model.maDH,
        productId: model.maSP,
        quantity: model.soLuong,
        priceAtPurchase: model.giaLucMua,
      )).toList();
    } catch (e) {
      throw Exception('Failed to get order details: $e');
    }
  }
}