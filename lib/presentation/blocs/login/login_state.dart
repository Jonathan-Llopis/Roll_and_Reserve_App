import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

sealed class LoginState extends Equatable {
  final String? email;
  final bool? isEmailUsed;
  final bool? isNameUsed;
  final bool? validatePassword;
  final String? id;
  final UserEntity? user;
  final List<UserEntity>? users;

  const LoginState({
    this.email,
    this.isEmailUsed,
    this.isNameUsed,
    this.validatePassword,
    this.id,
    this.user,
    this.users,
  });

  bool get isLoading => this is LoginLoading;
  String? get errorMessage =>
      this is LoginFailure ? (this as LoginFailure).message : null;

  @override
  List<Object?> get props => [
        email,
        isEmailUsed,
        isNameUsed,
        validatePassword,
        id,
        user,
        users,
      ];
}

class LoginInitial extends LoginState {
  const LoginInitial() : super();
}

class LoginLoading extends LoginState {
  const LoginLoading({
    super.email,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.id,
    super.user,
    super.users,
  });
}

class LoginSuccess extends LoginState {
  const LoginSuccess({
    super.email,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.id,
    super.user,
    super.users,
  });
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(
    this.message, {
    super.email,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.id,
    super.user,
    super.users,
  });

  @override
  List<Object?> get props => [super.props, message];
}
