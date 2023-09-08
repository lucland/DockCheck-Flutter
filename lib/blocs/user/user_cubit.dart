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
      print("Users fetched: $users");
      List<User> usersMapped =
          users.map((userMap) => User.fromMap(userMap)).toList();
      print(usersMapped[0].name);
      emit(UserLoaded(usersMapped));
    } catch (e) {
      emit(UserError("Failed to fetch users."));
    }
  }
}
