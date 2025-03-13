// lib/env/prod_env.dart
import 'env.dart';

class ProdEnv implements Env {
  @override
  String get apiUrl => 'https://your-production-api.com';
}