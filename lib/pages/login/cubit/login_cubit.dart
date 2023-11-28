import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial);

  Future<void> logIn(String email, String password) async {
    emit(LoginState.loading);
    try {
      emit(LoginState.success);
    } catch (e) {
      emit(LoginState.error);
    }
  }
}
