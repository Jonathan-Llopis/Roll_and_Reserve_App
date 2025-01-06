import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/sign_in_repository_impl.dart';
import 'package:roll_and_reserve/domain/usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reset_password.dart';
import 'package:roll_and_reserve/domain/usecases/sign_up_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/validate_pass_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/domain/usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/sign_out_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void configureDependencies() async {
  // BLocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<FirestoreUsersDatasource>(
    () => FirestoreUsersDatasource(),
  );
  sl.registerLazySingleton<UserDatasource>(
    () => UserDatasourceImpl(sl()),
  );

  // Repositorios

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      sl<FirebaseAuthDataSource>(),
      sl(),
      sl(),
      sl(),
    ),
  );
  // Casos de uso
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
    sl.registerLazySingleton<IsEmailUsedUsecase>(
    () => IsEmailUsedUsecase(sl()),
  );
  sl.registerLazySingleton<IsNameUsedUsecase>(
    () => IsNameUsedUsecase(sl()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl()),
  );
  sl.registerLazySingleton<SigninUserGoogleUseCase>(
    () => SigninUserGoogleUseCase(sl()),
  );
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUserUseCase>(
    () => SignUpUserUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserInfoUseCase>(
    () => UpdateUserInfoUseCase(sl()),
  );
  sl.registerLazySingleton<UpdatePasswordUsecase>(
    () => UpdatePasswordUsecase(sl()),
  );
  sl.registerLazySingleton<ValidatePasswordUsecase>(
    () => ValidatePasswordUsecase(sl()),
  );
  
   sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
}
