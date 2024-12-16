class LoginState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool? isEmailUsed;
   final bool? isNameUsed;
   final String? id;

  const LoginState(
      {this.isLoading = false,
      this.email,
      this.errorMessage,
      this.isEmailUsed,
      this.isNameUsed,
      this.id});

  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    bool? isEmailUsed,
    bool? isNameUsed,
    String? id
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      id: id ?? this.id
    );
  }

  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true);

  factory LoginState.success(String email) => LoginState(email: email);

  factory LoginState.isLogedIn(String id) => LoginState(id: id);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);
}
