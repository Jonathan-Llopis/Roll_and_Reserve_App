import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/datasources/review_datasource.dart';
import 'package:roll_and_reserve/data/datasources/shop_datasource.dart';
import 'package:roll_and_reserve/data/datasources/table_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/repositories/review_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/shop_repository_impl.dart';
import 'package:roll_and_reserve/data/repositories/table_repository_impl.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';
import 'package:roll_and_reserve/domain/repositories/table_repository.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/create_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/delete_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/review_usecases/get_all_review_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/create_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/delete_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_byowner_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_all_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_most_played_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_peak_reservation_houts_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_player_count_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_shops_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/get_total_reservations_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/shop_usecases/update_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/create_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/delete_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_byshop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/update_table_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/reviews/reviews_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void registerShopDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<ShopRemoteDataSource>(
    () => ShopsRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<TableRemoteDataSource>(
    () => TablesRemoteDataSourceImpl(sl<http.Client>()),
  );
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(sl<http.Client>()),
  );

  // Repositories
  sl.registerLazySingleton<ShopsRepository>(
    () => ShopRepositoryImpl(
      sl<ShopRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<TableRepository>(
    () => TableRepositoryImpl(
      sl<TableRemoteDataSource>(),
      sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(
      sl<ReviewRemoteDataSource>(),
      sl<SharedPreferences>(),
      sl<UserDatasource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<CreateShopsUseCase>(
    () => CreateShopsUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<DeleteShopsUseCase>(
    () => DeleteShopsUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetAllShopsUseCase>(
    () => GetAllShopsUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<UpdateShopsUseCase>(
    () => UpdateShopsUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetShopUseCase>(
    () => GetShopUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetAllShopsByOwnerUseCase>(
    () => GetAllShopsByOwnerUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetMostPlayedGamesUseCase>(
    () => GetMostPlayedGamesUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetPeakReservationHoursUseCase>(
    () => GetPeakReservationHoursUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetPlayerCountUseCase>(
    () => GetPlayerCountUseCase(sl<ShopsRepository>()),
  );
  sl.registerLazySingleton<GetTotalReservationsUseCase>(
    () => GetTotalReservationsUseCase(sl<ShopsRepository>()),
  );

  sl.registerLazySingleton<CreateTableUseCase>(
    () => CreateTableUseCase(sl<TableRepository>()),
  );
  sl.registerLazySingleton<UpdateTableUseCase>(
    () => UpdateTableUseCase(sl<TableRepository>()),
  );
  sl.registerLazySingleton<GetAllTablesUseCase>(
    () => GetAllTablesUseCase(sl<TableRepository>()),
  );
  sl.registerLazySingleton<DeleteTableUseCase>(
    () => DeleteTableUseCase(sl<TableRepository>()),
  );
  sl.registerLazySingleton<GetAllTablesByShopUseCase>(
    () => GetAllTablesByShopUseCase(sl<TableRepository>()),
  );

  sl.registerLazySingleton<GetAllReviewUseCase>(
    () => GetAllReviewUseCase(sl<ReviewRepository>()),
  );
  sl.registerLazySingleton<CreateReviewUseCase>(
    () => CreateReviewUseCase(sl<ReviewRepository>()),
  );
  sl.registerLazySingleton<DeleteReviewUseCase>(
    () => DeleteReviewUseCase(sl<ReviewRepository>()),
  );

  // BLoCs
  sl.registerFactory<ShopBloc>(
    () => ShopBloc(
      createShopsUseCase: sl<CreateShopsUseCase>(),
      getShopsUseCase: sl<GetAllShopsUseCase>(),
      updateShopsUseCase: sl<UpdateShopsUseCase>(),
      deleteShopsUseCase: sl<DeleteShopsUseCase>(),
      getShopUseCase: sl<GetShopUseCase>(),
      getAllShopsByOwnerUseCase: sl<GetAllShopsByOwnerUseCase>(),
      getMostPlayedGames: sl<GetMostPlayedGamesUseCase>(),
      getTotalReservations: sl<GetTotalReservationsUseCase>(),
      getPlayerCount: sl<GetPlayerCountUseCase>(),
      getPeakReservationHours: sl<GetPeakReservationHoursUseCase>(),
    ),
  );

  sl.registerFactory<TableBloc>(
    () => TableBloc(
      createTablesUseCase: sl<CreateTableUseCase>(),
      getTablesUseCase: sl<GetAllTablesUseCase>(),
      updateTablesUseCase: sl<UpdateTableUseCase>(),
      deleteTablesUseCase: sl<DeleteTableUseCase>(),
      getAllTablesByShopUseCase: sl<GetAllTablesByShopUseCase>(),
    ),
  );

  sl.registerFactory<ReviewBloc>(
    () => ReviewBloc(
      createReviewUseCase: sl<CreateReviewUseCase>(),
      getReviewUseCase: sl<GetAllReviewUseCase>(),
      deleteReviewUseCase: sl<DeleteReviewUseCase>(),
    ),
  );
}
