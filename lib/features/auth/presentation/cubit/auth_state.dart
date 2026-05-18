import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponseEntity authResponse;

  AuthSuccess(this.authResponse);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}

class AuthGuest extends AuthState {}
