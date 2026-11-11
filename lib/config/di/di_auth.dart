import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/user_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
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
import 'package:roll_and_reserve/presentation/blocs/admin/admin_user_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/user_profile/user_profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerAuthDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<FirestoreUsersDatasource>(
    () => FirestoreUsersDatasource(),
  );

  // Repository
  sl.registerLazySingleton<UserRespository>(
    () => UserRespositoryImpl(
      sl<FirebaseAuthDataSource>(),
      sl<SharedPreferences>(),
      sl<FirestoreUsersDatasource>(),
      sl<UserDatasource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<IsEmailUsedUsecase>(
    () => IsEmailUsedUsecase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<IsNameUsedUsecase>(
    () => IsNameUsedUsecase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<SigninUserGoogleUseCase>(
    () => SigninUserGoogleUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<SignUpUserUseCase>(
    () => SignUpUserUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<UpdateUserInfoUseCase>(
    () => UpdateUserInfoUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<UpdatePasswordUsecase>(
    () => UpdatePasswordUsecase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<ValidatePasswordUsecase>(
    () => ValidatePasswordUsecase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(sl<UserRespository>()),
  );
  sl.registerLazySingleton<GetAllUsersUseCase>(
    () => GetAllUsersUseCase(sl<UserRespository>()),
  );

  // BLoCs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
      signInUserUseCase: sl<SigninUserUseCase>(),
      signOutUserUseCase: sl<SignoutUserUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      signInUserGoogleUseCase: sl<SigninUserGoogleUseCase>(),
      signUpUserUseCase: sl<SignUpUserUseCase>(),
      restorPasswordUseCase: sl<ResetPasswordUseCase>(),
      isEmailUsedUseCase: sl<IsEmailUsedUsecase>(),
      isNameUsedUseCase: sl<IsNameUsedUsecase>(),
      updateUserInfoUseCase: sl<UpdateUserInfoUseCase>(),
      updatePasswordUsecase: sl<UpdatePasswordUsecase>(),
      validatePasswordUsecase: sl<ValidatePasswordUsecase>(),
      getUserInfoUseCase: sl<GetUserInfoUseCase>(),
      getAllUsersUseCase: sl<GetAllUsersUseCase>(),
    ),
  );

  sl.registerFactory<AdminUserBloc>(
    () => AdminUserBloc(
      getAllUsersUseCase: sl<GetAllUsersUseCase>(),
    ),
  );

  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      getUserInfoUseCase: sl<GetUserInfoUseCase>(),
      updateUserInfoUseCase: sl<UpdateUserInfoUseCase>(),
      updatePasswordUsecase: sl<UpdatePasswordUsecase>(),
      validatePasswordUsecase: sl<ValidatePasswordUsecase>(),
      isEmailUsedUseCase: sl<IsEmailUsedUsecase>(),
      isNameUsedUseCase: sl<IsNameUsedUsecase>(),
    ),
  );
}
