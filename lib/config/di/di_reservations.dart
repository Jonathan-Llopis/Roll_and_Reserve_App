import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/datasources/category_games_datasource.dart';
import 'package:roll_and_reserve/data/datasources/difficulty_datasource.dart';
import 'package:roll_and_reserve/data/datasources/game_datasource.dart';
import 'package:roll_and_reserve/data/datasources/reserve_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/category_game_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/difficulty_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/game_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/reserve_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/category_game_repository.dart';
import 'package:roll_and_reserve/domain/repositories/difficulty_repository.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/create_event_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/event_usecases/get_events_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_categories_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_difficulties_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/search_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/add_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/confirm_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/create_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_bydate_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserve_withuser_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserves_from_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/update_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_last_ten_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/event/event_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/player/player_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerReservationDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<DifficultyRemoteDataSource>(
    () => DifficultyRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<GameRemoteDataSource>(
    () => GameRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<CategoryGameRemoteDataSource>(
    () => CategoryGameRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<ReserveRemoteDataSource>(
    () => ReservesRemoteDataSourceImpl(sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<DifficultyRepository>(
    () => DifficultyRepositoryImpl(
      sl<DifficultyRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(
      sl<GameRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<CategoryGameRepository>(
    () => CategoryGameRepositoryImpl(
      sl<CategoryGameRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<ReserveRepository>(
    () => ReserveRepositoryImpl(
      sl<ReserveRemoteDataSource>(),
      sl<SharedPreferences>(),
      sl<UserDatasource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<GetAllDifficultyUseCase>(
    () => GetAllDifficultyUseCase(sl<DifficultyRepository>()),
  );
  sl.registerLazySingleton<GetAllGameUseCase>(
    () => GetAllGameUseCase(sl<GameRepository>()),
  );
  sl.registerLazySingleton<GetAllCategoryGamesUseCase>(
    () => GetAllCategoryGamesUseCase(sl<CategoryGameRepository>()),
  );
  sl.registerLazySingleton<SearchGamesUseCase>(
    () => SearchGamesUseCase(sl<GameRepository>()),
  );

  sl.registerLazySingleton<GetAllReservesUseCase>(
    () => GetAllReservesUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<CreateReserveUseCase>(
    () => CreateReserveUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<UpdateReserveUseCase>(
    () => UpdateReserveUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<DeleteReserveUseCase>(
    () => DeleteReserveUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<GetAllReserveBydateUsecase>(
    () => GetAllReserveBydateUsecase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<GetReserveWithuserUsecase>(
    () => GetReserveWithuserUsecase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<GetReservesFromUserUseCase>(
    () => GetReservesFromUserUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<ConfirmateReserveUsecase>(
    () => ConfirmateReserveUsecase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<GetEventsShopUsecase>(
    () => GetEventsShopUsecase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<CreateEventsUsecase>(
    () => CreateEventsUsecase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<AddUserToReserveUseCase>(
    () => AddUserToReserveUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<DeleteUserOfReserveUseCase>(
    () => DeleteUserOfReserveUseCase(sl<ReserveRepository>()),
  );
  sl.registerLazySingleton<GetLastTenPlayersUseCase>(
    () => GetLastTenPlayersUseCase(sl<ReserveRepository>()),
  );

  // BLoCs
  sl.registerFactory<GameBloc>(
    () => GameBloc(
      getAllGameUseCase: sl<GetAllGameUseCase>(),
      getAllCategoryGamesUseCase: sl<GetAllCategoryGamesUseCase>(),
      getAllDifficultyUseCase: sl<GetAllDifficultyUseCase>(),
      searchGamesUseCase: sl<SearchGamesUseCase>(),
    ),
  );

  sl.registerFactory<EventBloc>(
    () => EventBloc(
      getEventsShopUsecase: sl<GetEventsShopUsecase>(),
      createEventsUsecase: sl<CreateEventsUsecase>(),
    ),
  );

  sl.registerFactory<PlayerBloc>(
    () => PlayerBloc(
      getLastTenPlayersUseCase: sl<GetLastTenPlayersUseCase>(),
      addUserToReserveUseCase: sl<AddUserToReserveUseCase>(),
      deleteUserToReserveUseCase: sl<DeleteUserOfReserveUseCase>(),
    ),
  );

  sl.registerFactory<ReserveBloc>(
    () => ReserveBloc(
      createReserveUseCase: sl<CreateReserveUseCase>(),
      getReserveUseCase: sl<GetAllReservesUseCase>(),
      deleteReserveUseCase: sl<DeleteReserveUseCase>(),
      getAllDifficultyUseCase: sl<GetAllDifficultyUseCase>(),
      getAllGameUseCase: sl<GetAllGameUseCase>(),
      getAllCategoryGamesUseCase: sl<GetAllCategoryGamesUseCase>(),
      addUserToReserveUseCase: sl<AddUserToReserveUseCase>(),
      deleteUserToReserveUseCase: sl<DeleteUserOfReserveUseCase>(),
      getAllReservesByDateUseCase: sl<GetAllReserveBydateUsecase>(),
      getReserveWithuserUsecase: sl<GetReserveWithuserUsecase>(),
      getReservesOfUserUseCase: sl<GetReservesFromUserUseCase>(),
      confirmateReserveUsecase: sl<ConfirmateReserveUsecase>(),
      getEventsShopUsecase: sl<GetEventsShopUsecase>(),
      createEventsUsecase: sl<CreateEventsUsecase>(),
      searchGamesUseCase: sl<SearchGamesUseCase>(),
      getLastTenPlayersUseCase: sl<GetLastTenPlayersUseCase>(),
      updateReserveUseCase: sl<UpdateReserveUseCase>(),
    ),
  );
}
