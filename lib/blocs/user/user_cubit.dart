import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit(this.userRepository) : super(UserInitial());

  fetchUsers() async {
    try {
      emit(UserLoading());
      var users = await userRepository.fetchUsers();
      print("Users fetched: ${users[0]}");
      List<User> usersMapped =
          users.map((userMap) => User.fromMap(userMap)).toList();
      print(usersMapped[0].nome);
      emit(UserLoaded(usersMapped));
    } catch (e) {
      print(e.toString());
      emit(UserError("Failed to fetch users."));
    }
  }

  searchUsers(String query) async {
    try {
      emit(UserLoading());
      var users = await userRepository.searchUsers(query);
      print("Users fetched: ${users[0]}");
      List<User> usersMapped =
          users.map((userMap) => User.fromMap(userMap)).toList();
      print(usersMapped[0].nome);
      emit(UserLoaded(usersMapped));
    } catch (e) {
      print(e.toString());
      emit(UserError("Failed to fetch users."));
    }
  }
}
