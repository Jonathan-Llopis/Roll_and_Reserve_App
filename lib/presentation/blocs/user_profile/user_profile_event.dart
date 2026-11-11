import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserProfileEvent extends UserProfileEvent {
  final String idGoogle;

  const FetchUserProfileEvent({required this.idGoogle});

  @override
  List<Object?> get props => [idGoogle];
}

class UpdateProfileInfoEvent extends UserProfileEvent {
  final UserEntity user;

  const UpdateProfileInfoEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserPasswordEvent extends UserProfileEvent {
  final String password;
  final String oldPassword;

  const UpdateUserPasswordEvent({
    required this.password,
    required this.oldPassword,
  });

  @override
  List<Object?> get props => [password, oldPassword];
}

class ValidateUserPasswordEvent extends UserProfileEvent {
  final String password;

  const ValidateUserPasswordEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

class CheckEmailOrUsernameUsedEvent extends UserProfileEvent {
  final String email;
  final String name;

  const CheckEmailOrUsernameUsedEvent({
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [email, name];
}
