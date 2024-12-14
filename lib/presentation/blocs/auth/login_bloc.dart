import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_out_user_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SigninUserGoogleUseCase signInUserGoogleUseCase;
  LoginBloc(
    this.signInUserUseCase,
    this.signOutUserUseCase,
    this.getCurrentUserUseCase,
    this.signInUserGoogleUseCase

  ) : super(LoginState.initial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signInUserUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (_) => emit(LoginState.success(event.email)),
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al verificar la autenticación")),
        (username) => emit(LoginState.success(username)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
          (failure) => emit(LoginState.failure("Fallo al realizar el logout")),
          (_) => emit(LoginState.initial()));
    });
     on<LoginGoogle>((event, emit) async {
      emit(LoginState.loading());
      final result = await signInUserGoogleUseCase(LoginParamsGoogle()

      );
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (_) => emit(LoginState.success('')),
      );
    });

  }
}
