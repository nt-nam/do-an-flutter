import '../models/delivery_staff_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../../domain/repositories/delivery_staff_repository.dart';

class DeliveryStaffRepositoryImpl implements DeliveryStaffRepository {
  final ApiService apiService;
  final AuthService authService;

  DeliveryStaffRepositoryImpl(this.apiService, this.authService);

  @override
  Future<List<DeliveryStaffModel>> getDeliveryStaff() async {
    final token = await authService.getToken();
    final data = await apiService.get('nhanviengiaohang', token: token);
    return (data as List).map((json) => DeliveryStaffModel.fromJson(json)).toList();
  }

  @override
  Future<DeliveryStaffModel> createDeliveryStaff(DeliveryStaffModel staff) async {
    final token = await authService.getToken();
    final data = await apiService.post('nhanviengiaohang', staff.toJson(), token: token);
    return DeliveryStaffModel.fromJson(data);
  }

  @override
  Future<DeliveryStaffModel> updateDeliveryStaff(DeliveryStaffModel staff) async {
    final token = await authService.getToken();
    final data = await apiService.put('nhanviengiaohang/${staff.maNVG}', staff.toJson(), token: token);
    return DeliveryStaffModel.fromJson(data);
  }
}