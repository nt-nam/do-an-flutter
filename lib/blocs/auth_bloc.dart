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
  final String? fullName; // Không bắt buộc
  final String? phone; // Không bắt buộc
  final String? address; // Không bắt buộc
  RegisterEvent(this.email, this.password, {this.fullName, this.phone, this.address});
}
class LogoutEvent extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user);
}
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
      if (event.email == 'test' && event.password == '123') {
        final user = UserModel(
          id: 1,
          email: event.email,
          role: 'customer',
          isActive: true,
          fullName: 'Người dùng thử',
          phone: '0123456789',
          address: '123 Đường Láng, Hà Nội',
        );
        emit(AuthAuthenticated(user));
      } else {
        throw Exception('Email hoặc mật khẩu không đúng');
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Mock register
      await Future.delayed(Duration(seconds: 1)); // Giả lập thời gian chờ
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch, // Giả lập MaTK tự tăng
        email: event.email,
        role: 'customer', // Mặc định VaiTro = 1 (customer)
        isActive: true, // Mặc định TrangThai = 1
        fullName: event.fullName, // Có thể null
        phone: event.phone, // Có thể null
        address: event.address, // Có thể null
      );
      emit(AuthAuthenticated(user));

      // Khi dùng API thật (PHP):
      // final response = await http.post(
      //   Uri.parse('http://your-php-server/auth/register.php'),
      //   body: jsonEncode({
      //     'Email': event.email,
      //     'MatKhau': event.password, // Nên hash trước khi gửi
      //     'VaiTro': 1, // Mặc định customer
      //     'TrangThai': 1, // Mặc định hoạt động
      //     'HoTen': event.fullName,
      //     'SDT': event.phone,
      //     'DiaChi': event.address,
      //   }),
      // );
      // if (response.statusCode == 201) {
      //   emit(AuthAuthenticated(UserModel.fromJson(jsonDecode(response.body))));
      // } else {
      //   throw Exception('Đăng ký thất bại');
      // }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(Duration(seconds: 1));
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}