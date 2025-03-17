import '../entities/delivery.dart';
import '../repositories/delivery_repository.dart';
import '../../data/models/delivery_model.dart';

class GetDeliveryStatusUseCase {
  final DeliveryRepository repository;

  GetDeliveryStatusUseCase(this.repository);

  Future<Delivery> call(int orderId) async {
    try {
      final deliveryModel = await repository.getDeliveryByOrderId(orderId);
      return _mapToEntity(deliveryModel);
    } catch (e) {
      throw Exception('Failed to get delivery status: $e');
    }
  }

  Delivery _mapToEntity(DeliveryModel model) {
    return Delivery(
      id: model.maVC,
      orderId: model.maDH,
      staffId: model.maNVG,
      deliveryDate: model.ngayGiao,
      status: model.trangThai,
    );
  }
}