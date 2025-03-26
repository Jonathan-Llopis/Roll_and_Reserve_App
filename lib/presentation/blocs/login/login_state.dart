import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class LoginState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool? isEmailUsed;
  final bool? isNameUsed;
  final bool? validatePassword;
  final String? id;
  final UserEntity? user;
  final List<UserEntity>? users;


  const LoginState(
      {this.isLoading = false,
      this.email,
      this.errorMessage,
      this.isEmailUsed,
      this.isNameUsed,
      this.id,
      this.user,
      this.validatePassword,
      this.users,
     });

  LoginState copyWith(
      {bool? isLoading,
      String? email,
      String? errorMessage,
      bool? isEmailUsed,
      bool? isNameUsed,
      String? id,
      UserEntity? user,
      bool? validatePassword,
      List<UserEntity>? users,
      }) {
    return LoginState(
        isLoading: isLoading ?? this.isLoading,
        email: email ?? this.email,
        errorMessage: errorMessage,
        isEmailUsed: isEmailUsed ?? this.isEmailUsed,
        isNameUsed: isNameUsed ?? this.isNameUsed,
        id: id ?? this.id,
        user: user ?? this.user,
        validatePassword: validatePassword ?? this.validatePassword,
        users: users ?? this.users,
        );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading(LoginState state) =>
      state.copyWith(isLoading: true, errorMessage: null);

  factory LoginState.success(LoginState state, String email) =>
      state.copyWith(email: email, errorMessage: null, isLoading: false);

  factory LoginState.isLogedIn(LoginState state, UserEntity user) =>
      state.copyWith(user: user, errorMessage: null, isLoading: false);

  factory LoginState.failure(LoginState state, String errorMessage) =>
      state.copyWith(errorMessage: errorMessage, isLoading: false);

  factory LoginState.users(LoginState state, List<UserEntity> users) =>
      state.copyWith(users: users, isLoading: false, errorMessage: null);
}
