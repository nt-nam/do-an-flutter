import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../repositories/order_repository.dart';

class UpdateUserLevelUseCase {
  final UserRepository userRepository;
  final OrderRepository orderRepository;

  UpdateUserLevelUseCase({
    required this.userRepository,
    required this.orderRepository,
  });

  Future<UserModel?> execute(int userId) async {
    try {
      final updatedUser = await userRepository.updateUserLevel(userId);
      return updatedUser;
    } catch (e) {
      debugPrint('Error updating user level: $e');
      if (e is DioException) {
        debugPrint('DioError: ${e.response?.data}');
      }
      return null;
    }
  }
} 