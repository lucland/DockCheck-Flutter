import 'package:cripto_qr_googlemarine/repositories/user_repository.dart';
import 'package:cripto_qr_googlemarine/services/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  final LocalStorageService localStorageService;
  HomeCubit(
    this.userRepository,
    this.localStorageService,
  ) : super(HomeState());

  //fetch last added user
  void fetchLastUser() async {
    try {
      emit(HomeState(isLoading: true));
      //retrieve user_id from local storage
      String? userNumber = await localStorageService.getUserId();
      //fetch logged user
      User user = await userRepository.getUser(userNumber ?? "");
      emit(HomeState(loggedUser: user, isLoading: false));
    } catch (e) {
      emit(HomeState(resultMessage: e.toString(), isLoading: false));
    }
  }
}
