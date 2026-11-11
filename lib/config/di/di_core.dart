import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/core/network/token_provider.dart';
import 'package:roll_and_reserve/core/services/notification_service.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> registerCoreDependencies(GetIt sl) async {
  // External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core Services
  sl.registerLazySingleton<UserDatasource>(
    () => UserDatasourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<TokenProvider>(
    () => TokenProviderImpl(sharedPreferences: sl<SharedPreferences>()),
  );
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // Language BLoC
  sl.registerFactory<LanguageBloc>(
    () => LanguageBloc(sharedPreferences: sl<SharedPreferences>()),
  );
}
