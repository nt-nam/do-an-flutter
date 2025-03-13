// lib/domain/use_cases/auth/login.dart
import 'package:dartz/dartz.dart';
import '../../data/repositories/auth_repository.dart';
import '../../entities/user.dart';
import '../entities/profile.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<Either<String, User>> call(String email, String password) async {
    try {
      final user = await repository.login(email, password);
      return Right(User(id: user.id, email: user.email, role: user.role));
    } catch (e) {
      return Left(e.toString());
    }
  }
}