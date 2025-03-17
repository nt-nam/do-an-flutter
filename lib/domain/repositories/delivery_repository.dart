import '../../data/models/delivery_model.dart';

abstract class DeliveryRepository {
  Future<List<DeliveryModel>> getDeliveries();
  Future<DeliveryModel> getDeliveryByOrderId(int orderId);
  Future<DeliveryModel> updateDelivery(DeliveryModel delivery);
}