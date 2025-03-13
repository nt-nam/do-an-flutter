// lib/blocs/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

abstract class AuthEvent {}
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent(this.email, this.password);
}
class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String address;
  RegisterEvent(this.email, this.password, this.fullName, this.phone, this.address);
}
class LogoutEvent extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        phone: event.phone,
        address: event.address,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await authService.logout();
    emit(AuthUnauthenticated());
  }
}