import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_user_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_users_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/reset_password.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_out_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_up_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/validate_pass_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final UpdateUserInfoUseCase updateUserInfoUseCase;
  final UpdatePasswordUsecase updatePasswordUsecase;
  final ValidatePasswordUsecase validatePasswordUsecase;
  final GetUserInfoUseCase getUserInfoUseCase;
  final GetAllUsersUseCase getAllUsersUseCase;
  

  LoginBloc(
      this.signInUserUseCase,
      this.signOutUserUseCase,
      this.getCurrentUserUseCase,
      this.signInUserGoogleUseCase,
      this.signUpUserUseCase,
      this.restorPasswordUseCase,
      this.isEmailUsedUseCase,
      this.isNameUsedUseCase,
      this.updateUserInfoUseCase,
      this.updatePasswordUsecase,
      this.validatePasswordUsecase,
      this.getUserInfoUseCase,
      this.getAllUsersUseCase)
      : super(LoginState.initial()) {

    on<ButtonLoginPressed>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await signInUserUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(LoginState.failure(state,"Fallo al realizar el login")),
        (_) => emit(LoginState.success(state,event.email)),
      );
    });

    on<ButtonRegisterPressed>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await signUpUserUseCase(RegisterParams(
          email: event.email,
          password: event.password,
          name: event.name,
          username: event.username));
      result.fold(
        (failure) => emit(LoginState.failure(state,"Fallo al realizar el registro")),
        (_) => emit(LoginState.success(state,event.email)),
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(LoginState.failure(state,"Fallo al verificar la autenticación")),
        (user) => emit(LoginState.isLogedIn(state,user)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
          (failure) => emit(LoginState.failure(state,"Fallo al realizar el logout")),
          (_) => emit(LoginState.initial()));
    });

    on<LoginGoogle>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await signInUserGoogleUseCase(LoginParamsGoogle());
      await result.fold(
      (failure) async => emit(LoginState.failure(state,"Fallo al realizar el login")),
      (_) async {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('email') ?? '';
        emit(LoginState.success(state,email));
      },
      );
    });
    on<ResetPassword>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await restorPasswordUseCase(event.email);
      result.fold(
        (failure) =>
            emit(LoginState.failure(state,"Fallo al realizar la recuperacion")),
        (_) => emit(LoginState.success(state,'')),
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

    on<UpdateUserInfoEvent>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await updateUserInfoUseCase(event.user);
      result.fold(
        (failure) =>
            emit(LoginState.failure(state,"Fallo al realizar la actualización")),
        (_) {
          emit(LoginState.success(state,''));
          if(state.user?.role==0){
            add(GetAllUsersEvent());
          }
          add(CheckAuthentication());
        },
      );
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await updatePasswordUsecase(event.password, event.oldPassword);
      result.fold(
        (failure) =>
            emit(LoginState.failure(state,"Fallo al realizar la recuperacion")),
        (_) => emit(LoginState.success(state,'')),
      );
    });

    on<ValidatePasswordEvent>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await validatePasswordUsecase(event.password);
      result.fold(
      (failure) =>
        emit(LoginState.failure(state,"Fallo al validar la contraseña")),
      (isValid) => emit(LoginState.success(state,isValid.toString())),
      );
    });

    on<GetUserInfoEvent>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await getUserInfoUseCase(event.idGoogle);
      result.fold(
      (failure) =>
        emit(LoginState.failure(state,"Fallo al obtener la información del usuario")),
      (user) => emit(LoginState.success(state,user.toString())),
      );
    });

    on<GetAllUsersEvent>((event, emit) async {
      emit(LoginState.loading(state,));
      final result = await getAllUsersUseCase(NoParams());
      result.fold(
      (failure) =>
        emit(LoginState.failure(state,"Fallo al obtener la lista de usuarios")),
      (users) => emit(LoginState.users(state,users)),
      );
    });
  }
}
