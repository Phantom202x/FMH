part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GuestLogin extends AuthEvent {
  final Map<String, dynamic> loginData;
  const GuestLogin({required this.loginData});
}


class AdminLogin extends AuthEvent {
  final String email;
  final String password;
  const AdminLogin({required this.email, required this.password});
}

class Logout extends AuthEvent {}

class DeleteAccount extends AuthEvent {
  final String userId;
  const DeleteAccount({required this.userId});

  @override
  List<Object> get props => [userId];
}

