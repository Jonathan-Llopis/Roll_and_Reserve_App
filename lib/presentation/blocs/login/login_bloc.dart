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
    this.getAllUsersUseCase,
  ) : super(const LoginInitial()) {
    on<ButtonLoginPressed>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await signInUserUseCase(
        LoginParams(
          email: event.email,
          password: event.password,
        ),
      );
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar el login',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) => emit(
          LoginSuccess(
            email: event.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });

    on<ButtonRegisterPressed>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await signUpUserUseCase(
        RegisterParams(
          email: event.email,
          password: event.password,
          name: event.name,
          username: event.username,
        ),
      );
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar el registro',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) => emit(
          LoginSuccess(
            email: event.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al verificar la autenticación',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (user) => emit(
          LoginSuccess(
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: user,
            users: state.users,
          ),
        ),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar el logout',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) => emit(const LoginInitial()),
      );
    });

    on<LoginGoogle>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await signInUserGoogleUseCase(LoginParamsGoogle());
      await result.fold(
        (failure) async => emit(
          LoginFailure(
            'Fallo al realizar el login',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) async {
          final prefs = await SharedPreferences.getInstance();
          final email = prefs.getString('email') ?? '';
          emit(
            LoginSuccess(
              email: email,
              isEmailUsed: state.isEmailUsed,
              isNameUsed: state.isNameUsed,
              validatePassword: state.validatePassword,
              id: state.id,
              user: state.user,
              users: state.users,
            ),
          );
        },
      );
    });
    on<ResetPassword>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await restorPasswordUseCase(event.email);
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar la recuperación',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) => emit(
          LoginSuccess(
            email: '',
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });
    on<IsEmailUserUsed>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final emailResult = await isEmailUsedUseCase(event.email);
      final nameResult = await isNameUsedUseCase(event.name);
      emit(
        LoginSuccess(
          email: state.email,
          isEmailUsed: emailResult.fold((_) => null, (isUsed) => isUsed),
          isNameUsed: nameResult.fold((_) => null, (isUsed) => isUsed),
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
    });

    on<UpdateUserInfoEvent>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await updateUserInfoUseCase(event.user);
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar la actualización',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) async {
          if (state.user?.role == 0) {
            await Future.delayed(Duration.zero, () => add(GetAllUsersEvent()));
          } else {
            await Future.delayed(
              Duration.zero,
              () => add(CheckAuthentication()),
            );
          }
        },
      );
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result =
          await updatePasswordUsecase(event.password, event.oldPassword);
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al realizar la recuperación',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (_) => emit(
          LoginSuccess(
            email: '',
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });

    on<ValidatePasswordEvent>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await validatePasswordUsecase(event.password);
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al validar la contraseña',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (isValid) => emit(
          LoginSuccess(
            email: isValid.toString(),
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });

    on<GetUserInfoEvent>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await getUserInfoUseCase(event.idGoogle);
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al obtener la información del usuario',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (user) => emit(
          LoginSuccess(
            email: user.toString(),
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
      );
    });

    on<GetAllUsersEvent>((event, emit) async {
      emit(
        LoginLoading(
          email: state.email,
          isEmailUsed: state.isEmailUsed,
          isNameUsed: state.isNameUsed,
          validatePassword: state.validatePassword,
          id: state.id,
          user: state.user,
          users: state.users,
        ),
      );
      final result = await getAllUsersUseCase(NoParams());
      result.fold(
        (failure) => emit(
          LoginFailure(
            'Fallo al obtener la lista de usuarios',
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: state.users,
          ),
        ),
        (users) => emit(
          LoginSuccess(
            email: state.email,
            isEmailUsed: state.isEmailUsed,
            isNameUsed: state.isNameUsed,
            validatePassword: state.validatePassword,
            id: state.id,
            user: state.user,
            users: users,
          ),
        ),
      );
    });
  }
}
