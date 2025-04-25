import '../../repositories/user_repository.dart';
import '../../repositories/order_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/order.dart';
import 'dart:developer' as developer;

class UpdateUserLevelUseCase {
  final UserRepository userRepository;
  final OrderRepository orderRepository;

  UpdateUserLevelUseCase({
    required this.userRepository,
    required this.orderRepository,
  });

  Future<UserModel> call(int accountId) async {
    try {
      developer.log('UpdateUserLevelUseCase: Đang cập nhật cấp độ cho tài khoản $accountId');
      
      // Lấy thông tin người dùng hiện tại
      final user = await userRepository.getUserByAccountId(accountId);
      developer.log('Thông tin người dùng hiện tại: MaND=${user.maND}, MaTK=${user.maTK}, CapDo=${user.capDo}');
      
      // Lấy danh sách tất cả đơn hàng của người dùng 
      final orders = await orderRepository.getOrdersByAccount(accountId);
      developer.log('Số lượng đơn hàng của người dùng: ${orders.length}');
      
      // Log thông tin chi tiết về đơn hàng
      if (orders.isNotEmpty) {
        developer.log('Thông tin các đơn hàng:');
        for (var i = 0; i < orders.length; i++) {
          developer.log('Đơn #${i+1}: MaDH=${orders[i].maDH}, Trạng thái=${orders[i].trangThai}');
        }
      }
      
      // Đếm tất cả đơn hàng không phân biệt trạng thái
      final int orderCount = orders.length;
      
      // Xác định cấp độ mới dựa trên số lượng đơn hàng
      int newLevel;
      if (orderCount >= 10) {
        newLevel = 3; // Cấp 3 cho 10+ đơn hàng
      } else if (orderCount >= 5) {
        newLevel = 2; // Cấp 2 cho 5-9 đơn hàng
      } else {
        newLevel = 1; // Cấp 1 cho 0-4 đơn hàng
      }
      
      developer.log('Cấp độ hiện tại: ${user.capDo}, Cấp độ mới tính toán: $newLevel');
      
      // Chỉ cập nhật nếu cấp độ thay đổi
      if (newLevel != (user.capDo ?? 1)) {
        developer.log('Cấp độ thay đổi, đang cập nhật...');
        // Tạo model user mới với cấp độ đã cập nhật
        final updatedUser = UserModel(
          maND: user.maND,
          maTK: user.maTK,
          hoTen: user.hoTen,
          sdt: user.sdt,
          diaChi: user.diaChi,
          email: user.email,
          capDo: newLevel,
        );
        
        // Cập nhật cấp độ người dùng
        final result = await userRepository.updateUser(updatedUser);
        developer.log('Cập nhật cấp độ thành công: ${result.capDo}');
        return result;
      } else {
        developer.log('Cấp độ không thay đổi, không cần cập nhật');
      }
      
      // Trả về thông tin người dùng hiện tại nếu không có thay đổi
      return user;
    } catch (e) {
      developer.log('Lỗi khi cập nhật cấp độ người dùng: $e', error: e);
      throw Exception('Failed to update user level: $e');
    }
  }
} 