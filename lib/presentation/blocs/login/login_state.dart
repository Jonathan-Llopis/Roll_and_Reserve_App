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


  const LoginState(
      {this.isLoading = false,
      this.email,
      this.errorMessage,
      this.isEmailUsed,
      this.isNameUsed,
      this.id,
      this.user,
      this.validatePassword,
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
        );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true, errorMessage: null);

  factory LoginState.success(String email) => LoginState(email: email, errorMessage: null);

  factory LoginState.isLogedIn(UserEntity user) => LoginState(user: user, errorMessage: null);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);
}
