import 'package:dockcheck/repositories/user_repository.dart';
import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dockcheck/repositories/login_repository.dart';
import '../../../models/user.dart';
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
    SimpleLogger.info('Login attempt for user: $username');
    emit(LoginLoading());
    try {
      final response =
          await loginRepository.login(username, password, 'admin', 'mobile');

      if (response is Map<String, dynamic>) {
        SimpleLogger.info('Login response received: $response');

        await localStorageService.saveToken(response['token']);
        SimpleLogger.info('Token saved');

        await localStorageService.saveUserId(response['user_id']);
        SimpleLogger.info('User ID saved: ${response['user_id']}');

        SimpleLogger.info('Fetching user data for ID: ${response['user_id']}');
        User user = await userRepository.getUser(response['user_id']);
        SimpleLogger.info('User data received: $user');

        await localStorageService.saveUser(user);
        SimpleLogger.info('User data saved successfully');

        emit(LoginSuccess(
            userId: response['user_id'], token: response['token']));
      } else {
        SimpleLogger.warning('Invalid response type: ${response.runtimeType}');
        emit(LoginError("Login failed: Invalid response type"));
      }
    } catch (e) {
      SimpleLogger.severe('Login error: $e');
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
