class LoginState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool? isEmailUsed;

  const LoginState(
      {this.isLoading = false,
      this.email,
      this.errorMessage,
      this.isEmailUsed});

  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    bool? isEmailUsed,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
    );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true);

  factory LoginState.success(String email) => LoginState(email: email);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);

  factory LoginState.emailUsed(bool isUsed) {
    return LoginState(isEmailUsed: isUsed);
  }
}
