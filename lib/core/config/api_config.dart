// lib/core/config/api_config.dart
import '../../env/env.dart';

class ApiConfig {
  static late String baseUrl;

  static void init(Env env) {
    baseUrl = env.apiUrl;
  }
}