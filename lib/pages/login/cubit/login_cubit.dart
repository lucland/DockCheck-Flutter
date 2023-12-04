import 'package:cripto_qr_googlemarine/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cripto_qr_googlemarine/repositories/login_repository.dart';
import '../../../services/local_storage_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;
  final UserRepository userRepository;
  final LocalStorageService localStorageService;

  LoginCubit(
      this.loginRepository, this.userRepository, this.localStorageService)
      : super(LoginInitial());

  Future<void> logIn(String username, String password) async {
    print(password + username);
    print('login');
    emit(LoginLoading());
    try {
      final response =
          await loginRepository.login(username, password, 'admin', 'mobile');

      await localStorageService.deleteUserId();

      if (response.containsKey('token')) {
        await localStorageService.saveToken(response['token']);
        await localStorageService.saveUserId(response['user_id']);
        final user = await userRepository.getUser(response['user_id']);
        await localStorageService.saveUser(user);
        emit(LoginSuccess(
            userId: response['user_id'], token: response['token']));
      } else {
        print('token error');
        emit(LoginError("Login failed: Token not found"));
      }
    } catch (e) {
      print('error');
      print(e.toString());
      emit(LoginError("Login failed: ${e.toString()}"));
    }
  }

  void validateToken(String token) {
    if (token.isNotEmpty) {
      // Assuming token is valid for demonstration
      emit(LoginSuccess(userId: '', token: token));
    } else {
      emit(LoginError("Login failed: Token not found"));
    }
  }
}
