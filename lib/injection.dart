import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/shop_datasoruce.dart';
import 'package:roll_and_reserve/data/datasources/table_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/shop_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/sign_in_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/table_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/reset_password.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/sign_up_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/validate_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/create_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/delete_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/update_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/create_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/delete_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/update_table_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/auth/login_bloc.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/login_usecases/sign_out_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void configureDependencies() async {
  // BLocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
        sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<ShopBloc>(() => ShopBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<TableBloc>(() => TableBloc(sl(), sl(), sl(), sl()));

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
  sl.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TableRemoteDataSource>(
    () => TablesRemoteDataSourceImpl(sl()),
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
  sl.registerLazySingleton<ShopsRepository>(
    () => ShopRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<TableRepository>(
    () => TableRepositoryImpl(
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
  sl.registerLazySingleton<CreateShopsUseCase>(
    () => CreateShopsUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteShopsUseCase>(
    () => DeleteShopsUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllShopsUseCase>(
    () => GetAllShopsUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateShopsUseCase>(
    () => UpdateShopsUseCase(sl()),
  );
  sl.registerLazySingleton<CreateTableUseCase>(
    () => CreateTableUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateTableUseCase>(
    () => UpdateTableUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllTablesUseCase>(
    () => GetAllTablesUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteTableUseCase>(
    () => DeleteTableUseCase(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
