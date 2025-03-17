import '../../data/models/delivery_staff_model.dart';

abstract class DeliveryStaffRepository {
  Future<List<DeliveryStaffModel>> getDeliveryStaff();
  Future<DeliveryStaffModel> createDeliveryStaff(DeliveryStaffModel staff);
  Future<DeliveryStaffModel> updateDeliveryStaff(DeliveryStaffModel staff);
}