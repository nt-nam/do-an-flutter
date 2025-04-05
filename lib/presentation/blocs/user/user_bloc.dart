import 'package:bloc/bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../domain/entities/user.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(const UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserById>(_onLoadUserById);
    on<LoadUserByAccountId>(_onLoadUserByAccountId);
    on<UpdateUser>(_onUpdateUser);
  }

  // Phương thức ánh xạ từ UserModel sang User
  User _mapToEntity(UserModel model) {
    return User(
      id: model.maND,
      accountId: model.maTK,
      fullName: model.hoTen,
      phoneNumber: model.sdt,
      address: model.diaChi,
      email: model.email,
    );
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final userModels = await userRepository.getUsers(); // Trả về List<UserModel>
      final users = userModels.map(_mapToEntity).toList(); // Chuyển đổi thành List<User>
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserById(LoadUserById event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final userModel = await userRepository.getUserById(event.id);
      if (userModel == null) {
        emit(const UserError("Không tìm thấy người dùng với ID này"));
      } else {
        final user = _mapToEntity(userModel);
        emit(UserLoaded(user));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserByAccountId(LoadUserByAccountId event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final userModel = await userRepository.getUserByAccountId(event.accountId);
      if (userModel == null) {
        emit(const UserError("Không tìm thấy người dùng với Account ID này"));
      } else {
        final user = _mapToEntity(userModel);
        emit(UserLoaded(user));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      // Chuyển đổi từ User sang UserModel trước khi gửi đến repository
      final userModel = UserModel(
        maND: event.user.id,
        maTK: event.user.accountId,
        hoTen: event.user.fullName,
        sdt: event.user.phoneNumber,
        diaChi: event.user.address,
        email: event.user.email,
      );
      final updatedUserModel = await userRepository.updateUser(userModel);
      final updatedUser = _mapToEntity(updatedUserModel);
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}