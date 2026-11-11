import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

sealed class UserProfileState extends Equatable {
  final UserEntity? user;
  final bool? isEmailUsed;
  final bool? isNameUsed;
  final bool? validatePassword;
  final bool? isPasswordUpdated;

  const UserProfileState({
    this.user,
    this.isEmailUsed,
    this.isNameUsed,
    this.validatePassword,
    this.isPasswordUpdated,
  });

  bool get isLoading => this is UserProfileLoading;
  String? get errorMessage =>
      this is UserProfileFailure ? (this as UserProfileFailure).message : null;

  UserProfileState copyWith({
    UserEntity? user,
    bool? isEmailUsed,
    bool? isNameUsed,
    bool? validatePassword,
    bool? isPasswordUpdated,
  });

  @override
  List<Object?> get props => [
        user,
        isEmailUsed,
        isNameUsed,
        validatePassword,
        isPasswordUpdated,
      ];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial() : super();

  @override
  UserProfileState copyWith({
    UserEntity? user,
    bool? isEmailUsed,
    bool? isNameUsed,
    bool? validatePassword,
    bool? isPasswordUpdated,
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      validatePassword: validatePassword ?? this.validatePassword,
      isPasswordUpdated: isPasswordUpdated ?? this.isPasswordUpdated,
    );
  }
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading({
    super.user,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.isPasswordUpdated,
  });

  @override
  UserProfileState copyWith({
    UserEntity? user,
    bool? isEmailUsed,
    bool? isNameUsed,
    bool? validatePassword,
    bool? isPasswordUpdated,
  }) {
    return UserProfileLoading(
      user: user ?? this.user,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      validatePassword: validatePassword ?? this.validatePassword,
      isPasswordUpdated: isPasswordUpdated ?? this.isPasswordUpdated,
    );
  }
}

class UserProfileLoaded extends UserProfileState {
  const UserProfileLoaded({
    super.user,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.isPasswordUpdated,
  });

  @override
  UserProfileState copyWith({
    UserEntity? user,
    bool? isEmailUsed,
    bool? isNameUsed,
    bool? validatePassword,
    bool? isPasswordUpdated,
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      validatePassword: validatePassword ?? this.validatePassword,
      isPasswordUpdated: isPasswordUpdated ?? this.isPasswordUpdated,
    );
  }
}

class UserProfileFailure extends UserProfileState {
  final String message;

  const UserProfileFailure(
    this.message, {
    super.user,
    super.isEmailUsed,
    super.isNameUsed,
    super.validatePassword,
    super.isPasswordUpdated,
  });

  @override
  UserProfileState copyWith({
    UserEntity? user,
    bool? isEmailUsed,
    bool? isNameUsed,
    bool? validatePassword,
    bool? isPasswordUpdated,
  }) {
    return UserProfileFailure(
      message,
      user: user ?? this.user,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      validatePassword: validatePassword ?? this.validatePassword,
      isPasswordUpdated: isPasswordUpdated ?? this.isPasswordUpdated,
    );
  }

  @override
  List<Object?> get props => [...super.props, message];
}
