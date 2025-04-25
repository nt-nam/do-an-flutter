import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import '../models/user_model.dart';

class UserRepository {
  final Dio dio;

  UserRepository({required this.dio});

  Future<UserModel?> getUserProfile(int userId) async {
    try {
      final response = await dio.get('/user/profile/$userId');
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  Future<UserModel?> updateUserLevel(int userId) async {
    try {
      // Gọi API cập nhật cấp độ người dùng
      final response = await dio.put('/nguoidung', 
        queryParameters: {'id': userId},
        data: {}
      );
      
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return UserModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      debugPrint('Error updating user level: $e');
      if (e is DioException) {
        debugPrint('DioError: ${e.response?.data}');
      }
      return null;
    }
  }
} 