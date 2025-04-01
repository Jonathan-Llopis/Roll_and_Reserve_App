import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ButtonLoginPressed extends LoginEvent {
  final String email;
  final String password;

  ButtonLoginPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class ButtonRegisterPressed extends LoginEvent {
  final String email;
  final String password;
  final String name;
  final String username;

  ButtonRegisterPressed(
      {required this.email,
      required this.password,
      required this.name,
      required this.username});

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

class UpdateUserInfoEvent extends LoginEvent {
  final UserEntity user;

  UpdateUserInfoEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdatePasswordEvent extends LoginEvent {
  final String password;
  final String oldPassword;

  UpdatePasswordEvent({required this.password, required this.oldPassword});

  @override
  List<Object?> get props => [password, oldPassword];
}

class ValidatePasswordEvent extends LoginEvent {
  final String password;

  ValidatePasswordEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

class GetUserInfoEvent extends LoginEvent {
  final String idGoogle;

  GetUserInfoEvent({required this.idGoogle});

  @override
  List<Object?> get props => [idGoogle];
}

class LoadAvatar extends LoginEvent {}

class LogoutButtonPressed extends LoginEvent {}

class CheckAuthentication extends LoginEvent {}

class LoginGoogle extends LoginEvent {}

class GetAllUsersEvent extends LoginEvent {}

class UpdateUserAdminInfoEvent extends LoginEvent {
  final UserEntity user;

  UpdateUserAdminInfoEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
