// lib/env/dev_env.dart
import 'env.dart';

class DevEnv implements Env {
  @override
  String get apiUrl => 'http://localhost:3000';
}