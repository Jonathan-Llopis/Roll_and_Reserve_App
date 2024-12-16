import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final String name;

  RegisterButtonPressed({required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password];
}

class ResetPassword extends LoginEvent {
  final String email;

  ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class IsEmailUserUsed extends LoginEvent {
  final String email;
    final String name;

  IsEmailUserUsed({required this.email, required this.name});

  @override
  List<Object?> get props => [email, name];
}


class LogoutButtonPressed extends LoginEvent {}

class CheckAuthentication extends LoginEvent {}

class LoginGoogle extends LoginEvent {}
