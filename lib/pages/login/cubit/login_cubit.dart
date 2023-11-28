import 'package:flutter_bloc/flutter_bloc.dart';

enum LoginState { initial, loading, success, error }

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial);

  Future<void> logIn(String email, String password) async {
    emit(LoginState.loading);
    try {
      // Implement your login logic here
      emit(LoginState.success);
    } catch (e) {
      emit(LoginState.error);
    }
  }
}
