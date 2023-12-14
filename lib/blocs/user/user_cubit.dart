import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> fetchUsers() async {
    try {
      emit(UserLoading());

      var users = await userRepository.getAllUsers();

      emit(UserLoaded(users));
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      emit(UserError("Failed to fetch users."));
    }
  }

  Future<void> searchUsers(String query) async {
    try {
      emit(UserLoading());

      int page = 1;
      int pageSize = 10;

      var users = await userRepository.searchUsers(query, page, pageSize);
      emit(UserLoaded(users));
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      emit(UserError("Failed to fetch users."));
    }
  }
}
