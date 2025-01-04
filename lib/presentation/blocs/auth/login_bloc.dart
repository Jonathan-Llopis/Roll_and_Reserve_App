import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reset_password.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_out_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_up_user_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SigninUserGoogleUseCase signInUserGoogleUseCase;
  final SignUpUserUseCase signUpUserUseCase;
  final ResetPasswordUseCase restorPasswordUseCase;
  final IsEmailUsedUsecase isEmailUsedUseCase;
  final IsNameUsedUsecase isNameUsedUseCase;

  LoginBloc(
      this.signInUserUseCase,
      this.signOutUserUseCase,
      this.getCurrentUserUseCase,
      this.signInUserGoogleUseCase,
      this.signUpUserUseCase,
      this.restorPasswordUseCase,
      this.isEmailUsedUseCase,
      this.isNameUsedUseCase)
      : super(LoginState.initial()) {
        
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

    on<RegisterButtonPressed>((event, emit) async {
      emit(LoginState.loading());
      final result = await signUpUserUseCase(RegisterParams(
          email: event.email, password: event.password, name: event.name, username: event.username));
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el registro")),
        (_) => emit(LoginState.success(event.email)),
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al verificar la autenticación")),
        (user) => emit(LoginState.isLogedIn(user)),
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
      final result = await signInUserGoogleUseCase(LoginParamsGoogle());
      result.fold(
        (failure) => emit(LoginState.failure("Fallo al realizar el login")),
        (_) => emit(LoginState.success('')),
      );
    });
    on<ResetPassword>((event, emit) async {
      emit(LoginState.loading());
      final result = await restorPasswordUseCase(event.email);
      result.fold(
        (failure) =>
            emit(LoginState.failure("Fallo al realizar la recuperacion")),
        (_) => emit(LoginState.success('')),
      );
    });
    on<IsEmailUserUsed>((event, emit) async {
      emit(LoginState(isLoading: true));
      final emailResult = await isEmailUsedUseCase(event.email);
      final nameResult = await isNameUsedUseCase(event.name);
      emit(LoginState(
        isLoading: false,
        isEmailUsed: emailResult.fold((_) => null, (isUsed) => isUsed),
        isNameUsed: nameResult.fold((_) => null, (isUsed) => isUsed),
      ));
    });
  }
}
