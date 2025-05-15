part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AdminInit extends AuthState {}

class GuestInit extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
}

class AuthSuccess extends AuthState {
  //final Map authData;
  const AuthSuccess();
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}

class Unauthorized extends AuthState {}

class EmailVerificationRequired extends AuthState {}
