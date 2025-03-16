import 'package:roll_and_reserve/data/datasources/category_games_datasource.dart';
import 'package:roll_and_reserve/data/datasources/chat_datasource.dart';
import 'package:roll_and_reserve/data/datasources/difficulty_datasource.dart';
import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/game_datasource.dart';
import 'package:roll_and_reserve/data/datasources/reserve_datasource.dart';
import 'package:roll_and_reserve/data/datasources/review_datasource.dart';
import 'package:roll_and_reserve/data/datasources/shop_datasoruce.dart';
import 'package:roll_and_reserve/data/datasources/table_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/category_game_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/chat_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/difficulty_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/game_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/reserve_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/review_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/shop_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/user_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/table_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/category_game_repository.dart';
import 'package:roll_and_reserve/domain/repositories/chat_repository.dart';
import 'package:roll_and_reserve/domain/repositories/difficulty_repository.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/send_message_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/chat_usecases/start_chat_usecases.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/search_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_last_ten_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_user_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_users_info_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_email_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/is_name_used_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/reset_password.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_up_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/update_user_info.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/validate_pass_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/confirmate_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/create_event_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/create_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_categories_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_dificulties_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_bydate_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_events_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserve_withuser_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserves_from_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/update_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/create_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/delete_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/get_all_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/create_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/delete_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_byowner_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/update_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/add_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/create_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/delete_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_byshop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/update_table_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/chat/chat_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/language/language_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_current_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_in_user_google_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_in_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/sign_out_user_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void configureDependencies() async {
  // BLocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(),
        sl(), sl(), sl()),
  );
  sl.registerFactory<ShopBloc>(
      () => ShopBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<TableBloc>(() => TableBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ReviewBloc>(() => ReviewBloc(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory<ReserveBloc>(() => ReserveBloc(sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<LanguageBloc>(() => LanguageBloc(sl()));
  sl.registerFactory<ChatBloc>(() => ChatBloc(sl(), sl()));
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
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DifficultyRemoteDataSource>(
    () => DifficultyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<GameRemoteDataSource>(
    () => GameRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CategoryGameRemoteDataSource>(
    () => CategoryGameRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ReserveRemoteDataSource>(
    () => ReservesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );
  // Repositorios

  sl.registerLazySingleton<UserRespository>(
    () => UserRespositoryImpl(
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
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<DifficultyRepository>(
    () => DifficultyRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<CategoryGameRepository>(
    () => CategoryGameRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<ReserveRepository>(
    () => ReserveRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl(),
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
  sl.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(sl()),
  );
  sl.registerLazySingleton<AddUserToReserveUseCase>(
    () => AddUserToReserveUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteUserOfReserveUseCase>(
    () => DeleteUserOfReserveUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllReservesUseCase>(
    () => GetAllReservesUseCase(sl()),
  );
  sl.registerLazySingleton<CreateReserveUseCase>(
    () => CreateReserveUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateReserveUseCase>(
    () => UpdateReserveUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteReserveUseCase>(
    () => DeleteReserveUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllCategoryGamesUseCase>(
    () => GetAllCategoryGamesUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllGameUseCase>(
    () => GetAllGameUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllReviewUseCase>(
    () => GetAllReviewUseCase(sl()),
  );
  sl.registerLazySingleton<CreateReviewUseCase>(
    () => CreateReviewUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteReviewUseCase>(
    () => DeleteReviewUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllDifficultyUseCase>(
    () => GetAllDifficultyUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllUsersUseCase>(
    () => GetAllUsersUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllReserveBydateUsecase>(
    () => GetAllReserveBydateUsecase(sl()),
  );
  sl.registerLazySingleton<GetReserveWithuserUsecase>(
    () => GetReserveWithuserUsecase(sl()),
  );
  sl.registerLazySingleton<GetShopUseCase>(
    () => GetShopUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllShopsByOwnerUseCase>(
    () => GetAllShopsByOwnerUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllTablesByShopUseCase>(
    () => GetAllTablesByShopUseCase(sl()),
  );
  sl.registerLazySingleton<GetReservesFromUserUseCase>(
    () => GetReservesFromUserUseCase(sl()),
  );

  sl.registerLazySingleton<ConfirmateReserveUsecase>(
    () => ConfirmateReserveUsecase(sl()),
  );
  sl.registerLazySingleton<GetEventsShopUsecase>(
    () => GetEventsShopUsecase(sl()),
  );
  sl.registerLazySingleton<CreateEventsUsecase>(
    () => CreateEventsUsecase(sl()),
  );
  sl.registerLazySingleton<StartChatUseCase>(
    () => StartChatUseCase(sl()),
  );
  sl.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(sl()),
  );
   sl.registerLazySingleton<SearchGamesUseCase>(
    () => SearchGamesUseCase(sl()),
  );
sl.registerLazySingleton<GetLastTenPlayersUseCase>(
    () => GetLastTenPlayersUseCase(sl()),
  );


  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
