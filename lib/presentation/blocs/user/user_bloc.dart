import 'package:bloc/bloc.dart';
import '../../../domain/repositories/user_repository.dart';
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

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final users = await userRepository.getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserById(LoadUserById event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final user = await userRepository.getUserById(event.id);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onLoadUserByAccountId(LoadUserByAccountId event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final user = await userRepository.getUserByAccountId(event.accountId);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(const UserLoading());
    try {
      final updatedUser = await userRepository.updateUser(event.user);
      emit(UserLoaded(updatedUser));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}