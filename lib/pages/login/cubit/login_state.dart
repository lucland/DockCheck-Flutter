abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String userId;
  final String token;

  LoginSuccess({required this.userId, required this.token});
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
