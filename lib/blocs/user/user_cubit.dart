import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  Future<void> fetchUsers() async {
    try {
      emit(UserLoading());

      // Fetch users with default limit and offset
      var users = await userRepository.getAllUsers();

      emit(UserLoaded(users));
    } catch (e) {
      print(e.toString());
      emit(UserError("Failed to fetch users."));
    }
  }

  Future<void> searchUsers(String query) async {
    try {
      emit(UserLoading());
      // Assuming the default page number and page size
      int page = 1; // You can modify this as needed
      int pageSize = 10; // You can modify this as needed

      var users = await userRepository.searchUsers(query, page, pageSize);
      emit(UserLoaded(users));
    } catch (e) {
      print(e.toString());
      emit(UserError("Failed to fetch users."));
    }
  }
}
