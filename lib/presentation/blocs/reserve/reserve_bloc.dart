import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/add_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/confirmate_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/create_event_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/create_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/delete_user_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_categories_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_dificulties_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_bydate_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_all_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_events_shop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserve_withuser_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/get_reserves_from_user_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/search_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/reserve_usecases/update_reserve_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/user_usecases/get_last_ten_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';

class ReserveBloc extends Bloc<ReserveEvent, ReserveState> {
  final CreateReserveUseCase createReserveUseCase;
  final GetAllReservesUseCase getReserveUseCase;
  final DeleteReserveUseCase deleteReserveUseCase;
  final GetAllDifficultyUseCase getAllDifficultyUseCase;
  final GetAllGameUseCase getAllGameUseCase;
  final GetAllCategoryGamesUseCase getAllCategoryGamesUseCase;
  final AddUserToReserveUseCase addUserToReserveUseCase;
  final DeleteUserOfReserveUseCase deleteUserToReserveUseCase;
  final GetAllReserveBydateUsecase getAllReservesByDateUseCase;
  final GetReserveWithuserUsecase getReserveWithuserUsecase;
  final GetReservesFromUserUseCase getReservesOfUserUseCase;
  final ConfirmateReserveUsecase confirmateReserveUsecase;
  final GetEventsShopUsecase getEventsShopUsecase;
  final CreateEventsUsecase createEventsUsecase;
  final SearchGamesUseCase searchGamesUseCase;
  final GetLastTenPlayersUseCase getLastTenPlayersUseCase;
  final UpdateReserveUseCase updateReserveUseCase;

  ReserveBloc(
    this.createReserveUseCase,
    this.getReserveUseCase,
    this.deleteReserveUseCase,
    this.getAllDifficultyUseCase,
    this.getAllGameUseCase,
    this.getAllCategoryGamesUseCase,
    this.addUserToReserveUseCase,
    this.deleteUserToReserveUseCase,
    this.getAllReservesByDateUseCase,
    this.getReserveWithuserUsecase,
    this.getReservesOfUserUseCase,
    this.confirmateReserveUsecase,
    this.getEventsShopUsecase,
    this.createEventsUsecase,
    this.searchGamesUseCase,
    this.getLastTenPlayersUseCase,
    this.updateReserveUseCase,
  ) : super(const ReserveInitial()) {
    on<GetReservesEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      try {
        final reservesFuture = getReserveUseCase(NoParams());
        final categoriesFuture = getAllCategoryGamesUseCase(NoParams());
        final gamesFuture = getAllGameUseCase(NoParams());
        final difficultiesFuture = getAllDifficultyUseCase(NoParams());

        final results = await Future.wait([
          reservesFuture,
          categoriesFuture,
          gamesFuture,
          difficultiesFuture,
        ]);
        final reservesResult =
            results[0] as Either<Failure, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Failure, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Failure, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Failure, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) => emit(
            ReserveFailure(
              'Error al cargar reservas',
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          ),
          (reserves) {
            categoriesResult.fold(
              (failure) => emit(
                ReserveFailure(
                  'Error al cargar categorías de juegos',
                  idReserve: state.idReserve,
                  reserves: reserves,
                  reserve: state.reserve,
                  difficulties: state.difficulties,
                  games: state.games,
                  searchedGames: state.searchedGames,
                  gameCategories: state.gameCategories,
                  reservesOfUser: state.reservesOfUser,
                  eventsShop: state.eventsShop,
                  lastUsers: state.lastUsers,
                  filterTables: state.filterTables,
                ),
              ),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                    ReserveFailure(
                      'Error al cargar juegos',
                      idReserve: state.idReserve,
                      reserves: reserves,
                      reserve: state.reserve,
                      difficulties: state.difficulties,
                      games: state.games,
                      searchedGames: state.searchedGames,
                      gameCategories: categories,
                      reservesOfUser: state.reservesOfUser,
                      eventsShop: state.eventsShop,
                      lastUsers: state.lastUsers,
                      filterTables: state.filterTables,
                    ),
                  ),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(
                        ReserveFailure(
                          'Error al cargar dificultades',
                          idReserve: state.idReserve,
                          reserves: reserves,
                          reserve: state.reserve,
                          difficulties: state.difficulties,
                          games: games,
                          searchedGames: state.searchedGames,
                          gameCategories: categories,
                          reservesOfUser: state.reservesOfUser,
                          eventsShop: state.eventsShop,
                          lastUsers: state.lastUsers,
                          filterTables: state.filterTables,
                        ),
                      ),
                      (difficulties) {
                        emit(
                          ReserveSuccess(
                            reserves: reserves,
                            games: games,
                            gameCategories: categories,
                            difficulties: difficulties,
                            idReserve: state.idReserve,
                            reserve: state.reserve,
                            searchedGames: state.searchedGames,
                            reservesOfUser: state.reservesOfUser,
                            eventsShop: state.eventsShop,
                            lastUsers: state.lastUsers,
                            filterTables: state.filterTables,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(
          ReserveFailure(
            'Error inesperado: $e',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        );
      }
    });

    on<GetReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getReserveUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al realizar la recuperación',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (reservess) {
          final reserves = reservess
              .firstWhere((reserves) => reserves.id == event.idReserve);
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: reserves,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
          add(GetAllCategoryGameEvent());
          add(GetAllGameEvent());
          add(GetAllDifficultyEvent());
        },
      );
    });

    on<CreateReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await createReserveUseCase(event.reserve);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al crear reserva',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (id) {
          if (event.idUser != '') {
            add(
              AddUserToReserveEvent(
                idReserve: id,
                idUser: event.idUser,
                idTable: event.reserve.tableId,
                dateReserve: event.dateReserve,
                searchDateTime: event.dateReserve,
              ),
            );
          }
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<DeleteReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await deleteReserveUseCase(event.idReserve);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al eliminar tienda',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (_) {
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
          add(GetReservesEvent());
        },
      );
    });

    on<GetAllDifficultyEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getAllDifficultyUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al realizar la recuperación',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (dificulties) => emit(
          ReserveSuccess(
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: dificulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
      );
    });

    on<GetAllGameEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getAllGameUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al realizar la recuperación',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (games) => emit(
          ReserveSuccess(
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
      );
    });

    on<GetAllCategoryGameEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getAllCategoryGamesUseCase(NoParams());
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al realizar la recuperación',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (categorygames) => emit(
          ReserveSuccess(
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: categorygames,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
      );
    });

    on<AddUserToReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final params = UserToReserveUseCaseParams(
        idReserve: event.idReserve,
        idUser: event.idUser,
      );
      final result = await addUserToReserveUseCase(params);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al agregar usuario a la mesa',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (_) {
          add(
            GetReserveByDateEvent(
              dateReserve: event.searchDateTime,
              idTable: event.idTable,
            ),
          );
          add(GetReservesByUserEvent(idUser: event.idUser));
          add(
            GetReserveWithUsers(
              idReserve: event.idReserve,
            ),
          );

          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<DeleteUserOfReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final params = UserToReserveUseCaseParams(
        idReserve: event.idReserve,
        idUser: event.idUser,
      );
      final result = await deleteUserToReserveUseCase(params);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al eliminar usuario de la mesa',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (_) {
          add(GetReservesByUserEvent(idUser: event.idUser));
          add(
            GetReserveByDateEvent(
              dateReserve: event.dateReserve,
              idTable: event.idTable,
            ),
          );
          add(
            GetReserveWithUsers(
              idReserve: event.idReserve,
            ),
          );
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<GetReserveByTableEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );

      try {
        final reservesFuture = getReserveUseCase(NoParams());
        final categoriesFuture = getAllCategoryGamesUseCase(NoParams());
        final gamesFuture = getAllGameUseCase(NoParams());
        final difficultiesFuture = getAllDifficultyUseCase(NoParams());

        final results = await Future.wait([
          reservesFuture,
          categoriesFuture,
          gamesFuture,
          difficultiesFuture,
        ]);
        final reservesResult =
            results[0] as Either<Failure, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Failure, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Failure, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Failure, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) => emit(
            ReserveFailure(
              'Error al cargar reservas',
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          ),
          (reserves) {
            categoriesResult.fold(
              (failure) => emit(
                ReserveFailure(
                  'Error al cargar categorías de juegos',
                  idReserve: state.idReserve,
                  reserves: reserves,
                  reserve: state.reserve,
                  difficulties: state.difficulties,
                  games: state.games,
                  searchedGames: state.searchedGames,
                  gameCategories: state.gameCategories,
                  reservesOfUser: state.reservesOfUser,
                  eventsShop: state.eventsShop,
                  lastUsers: state.lastUsers,
                  filterTables: state.filterTables,
                ),
              ),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                    ReserveFailure(
                      'Error al cargar juegos',
                      idReserve: state.idReserve,
                      reserves: reserves,
                      reserve: state.reserve,
                      difficulties: state.difficulties,
                      games: state.games,
                      searchedGames: state.searchedGames,
                      gameCategories: categories,
                      reservesOfUser: state.reservesOfUser,
                      eventsShop: state.eventsShop,
                      lastUsers: state.lastUsers,
                      filterTables: state.filterTables,
                    ),
                  ),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(
                        ReserveFailure(
                          'Error al cargar dificultades',
                          idReserve: state.idReserve,
                          reserves: reserves,
                          reserve: state.reserve,
                          difficulties: state.difficulties,
                          games: games,
                          searchedGames: state.searchedGames,
                          gameCategories: categories,
                          reservesOfUser: state.reservesOfUser,
                          eventsShop: state.eventsShop,
                          lastUsers: state.lastUsers,
                          filterTables: state.filterTables,
                        ),
                      ),
                      (difficulties) {
                        final reservesByTable = reserves
                            .where(
                              (reserve) => reserve.tableId == event.idTable,
                            )
                            .toList();

                        emit(
                          ReserveSuccess(
                            reserves: reservesByTable,
                            games: games,
                            gameCategories: categories,
                            difficulties: difficulties,
                            idReserve: state.idReserve,
                            reserve: state.reserve,
                            searchedGames: state.searchedGames,
                            reservesOfUser: state.reservesOfUser,
                            eventsShop: state.eventsShop,
                            lastUsers: state.lastUsers,
                            filterTables: state.filterTables,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(
          ReserveFailure(
            'Error inesperado: $e',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        );
      }
    });

    on<GetReserveByDateEvent>((event, emit) async {
      try {
        emit(
          ReserveLoading(
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        );
        final reservesFuture = getAllReservesByDateUseCase(
          GetReservesByDateUseCaseParams(
            date: event.dateReserve,
            idTable: event.idTable,
          ),
        );
        final categoriesFuture = getAllCategoryGamesUseCase(NoParams());
        final gamesFuture = getAllGameUseCase(NoParams());
        final difficultiesFuture = getAllDifficultyUseCase(NoParams());

        final results = await Future.wait([
          reservesFuture,
          categoriesFuture,
          gamesFuture,
          difficultiesFuture,
        ]);
        final reservesResult =
            results[0] as Either<Failure, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Failure, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Failure, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Failure, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) => emit(
            ReserveFailure(
              'Error al cargar reservas',
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          ),
          (reserves) {
            final filteredReserves = reserves
                .where(
                  (reserve) =>
                      reserve.dayDate ==
                          DateFormat('dd - MM - yyyy')
                              .format(event.dateReserve) &&
                      reserve.tableId == event.idTable,
                )
                .toList();

            categoriesResult.fold(
              (failure) => emit(
                ReserveFailure(
                  'Error al cargar categorías de juegos',
                  idReserve: state.idReserve,
                  reserves: reserves,
                  reserve: state.reserve,
                  difficulties: state.difficulties,
                  games: state.games,
                  searchedGames: state.searchedGames,
                  gameCategories: state.gameCategories,
                  reservesOfUser: state.reservesOfUser,
                  eventsShop: state.eventsShop,
                  lastUsers: state.lastUsers,
                  filterTables: state.filterTables,
                ),
              ),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                    ReserveFailure(
                      'Error al cargar juegos',
                      idReserve: state.idReserve,
                      reserves: reserves,
                      reserve: state.reserve,
                      difficulties: state.difficulties,
                      games: state.games,
                      searchedGames: state.searchedGames,
                      gameCategories: categories,
                      reservesOfUser: state.reservesOfUser,
                      eventsShop: state.eventsShop,
                      lastUsers: state.lastUsers,
                      filterTables: state.filterTables,
                    ),
                  ),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(
                        ReserveFailure(
                          'Error al cargar dificultades',
                          idReserve: state.idReserve,
                          reserves: reserves,
                          reserve: state.reserve,
                          difficulties: state.difficulties,
                          games: games,
                          searchedGames: state.searchedGames,
                          gameCategories: categories,
                          reservesOfUser: state.reservesOfUser,
                          eventsShop: state.eventsShop,
                          lastUsers: state.lastUsers,
                          filterTables: state.filterTables,
                        ),
                      ),
                      (difficulties) {
                        emit(
                          ReserveSuccess(
                            reserves: filteredReserves,
                            games: games,
                            gameCategories: categories,
                            difficulties: difficulties,
                            idReserve: state.idReserve,
                            reserve: state.reserve,
                            searchedGames: state.searchedGames,
                            reservesOfUser: state.reservesOfUser,
                            eventsShop: state.eventsShop,
                            lastUsers: state.lastUsers,
                            filterTables: state.filterTables,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(
          ReserveFailure(
            'Error inesperado: $e',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        );
      }
    });

    on<GetReservesByShopEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );

      try {
        final reservesFuture = getReserveUseCase(NoParams());
        final results = await reservesFuture;

        results.fold(
          (failure) => emit(
            ReserveFailure(
              'Error al cargar reservas',
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          ),
          (reserves) {
            final reservesByShop = reserves
                .where(
                  (reserve) =>
                      event.currentShop.tablesShop.contains(reserve.tableId),
                )
                .toList();
            final filteredReserves = reservesByShop.where((reserve) {
              final isSameDate =
                  DateFormat('dd - MM - yyyy').parse(reserve.dayDate) ==
                      DateFormat('dd-MM-yyyy').parse(event.dateReserve);

              if (!isSameDate) return false;
              final reserveStartTime =
                  DateFormat('HH:mm').parse(reserve.horaInicio);
              final reserveEndTime = DateFormat('HH:mm').parse(reserve.horaFin);
              final eventStartTime = DateFormat('HH:mm')
                  .parse(event.startTime == '' ? '00:00' : event.startTime);
              final eventEndTime = DateFormat('HH:mm')
                  .parse(event.endTime == '' ? '23:59' : event.endTime);

              final isWithinTimeRange =
                  !(reserveEndTime.isBefore(eventStartTime) ||
                      reserveStartTime.isAfter(eventEndTime));
              return isWithinTimeRange;
            }).toList();
            Map<String, String> filterTables = {
              'startTime': event.startTime,
              'endTime': event.endTime,
              'dateReserve': event.dateReserve,
            };

            emit(
              ReserveSuccess(
                reserves: filteredReserves,
                filterTables: filterTables,
                idReserve: state.idReserve,
                reserve: state.reserve,
                difficulties: state.difficulties,
                games: state.games,
                searchedGames: state.searchedGames,
                gameCategories: state.gameCategories,
                reservesOfUser: state.reservesOfUser,
                eventsShop: state.eventsShop,
                lastUsers: state.lastUsers,
              ),
            );
          },
        );
      } catch (e) {
        emit(
          ReserveFailure(
            'Error inesperado: $e',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        );
      }
    });

    on<GetReserveWithUsers>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getReserveWithuserUsecase(
        IdReserveParams(idReserve: event.idReserve),
      );
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al obtener reservas del usuario',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (reserves) => emit(
          ReserveSuccess(
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: reserves,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
      );
    });

    on<GetReservesByUserEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final reservesFuture = getReservesOfUserUseCase(
        GetReserveFromUsersUseCaseParams(idUser: event.idUser),
      );
      final gamesFuture = getAllGameUseCase(NoParams());

      final results = await Future.wait([
        reservesFuture,
        gamesFuture,
      ]);

      final reservesResult = results[0] as Either<Failure, List<ReserveEntity>>;
      final gamesResult = results[1] as Either<Failure, List<GameEntity>>;

      reservesResult.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al obtener reservas del usuario',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (reserves) {
          gamesResult.fold(
            (failure) => emit(
              ReserveFailure(
                'Error al cargar juegos',
                idReserve: state.idReserve,
                reserves: state.reserves,
                reserve: state.reserve,
                difficulties: state.difficulties,
                games: state.games,
                searchedGames: state.searchedGames,
                gameCategories: state.gameCategories,
                reservesOfUser: reserves,
                eventsShop: state.eventsShop,
                lastUsers: state.lastUsers,
                filterTables: state.filterTables,
              ),
            ),
            (games) {
              emit(
                ReserveSuccess(
                  reservesOfUser: reserves,
                  games: games,
                  idReserve: state.idReserve,
                  reserves: state.reserves,
                  reserve: state.reserve,
                  difficulties: state.difficulties,
                  searchedGames: state.searchedGames,
                  gameCategories: state.gameCategories,
                  eventsShop: state.eventsShop,
                  lastUsers: state.lastUsers,
                  filterTables: state.filterTables,
                ),
              );
            },
          );
        },
      );
    });

    on<ConfirmReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await confirmateReserveUsecase(
        IdReserveParams(idReserve: event.idReserve),
      );
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al confirmar reserva',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (_) {
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
          add(
            GetReserveWithUsers(
              idReserve: event.idReserve,
            ),
          );
        },
      );
    });

    on<GetEventsEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final eventsFuture =
          getEventsShopUsecase(GetEventsParams(idShop: event.idShop));
      final gamesFuture = getAllGameUseCase(NoParams());

      final results = await Future.wait([
        eventsFuture,
        gamesFuture,
      ]);

      final eventsResult = results[0] as Either<Failure, List<ReserveEntity>>;
      final gamesResult = results[1] as Either<Failure, List<GameEntity>>;

      eventsResult.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al obtener eventos',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (events) {
          gamesResult.fold(
            (failure) => emit(
              ReserveFailure(
                'Error al cargar juegos',
                idReserve: state.idReserve,
                reserves: state.reserves,
                reserve: state.reserve,
                difficulties: state.difficulties,
                games: state.games,
                searchedGames: state.searchedGames,
                gameCategories: state.gameCategories,
                reservesOfUser: state.reservesOfUser,
                eventsShop: events,
                lastUsers: state.lastUsers,
                filterTables: state.filterTables,
              ),
            ),
            (games) {
              emit(
                ReserveSuccess(
                  eventsShop: events,
                  games: games,
                  idReserve: state.idReserve,
                  reserves: state.reserves,
                  reserve: state.reserve,
                  difficulties: state.difficulties,
                  searchedGames: state.searchedGames,
                  gameCategories: state.gameCategories,
                  reservesOfUser: state.reservesOfUser,
                  lastUsers: state.lastUsers,
                  filterTables: state.filterTables,
                ),
              );
            },
          );
        },
      );
    });

    on<CreateEventsEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await createEventsUsecase(event.reserves);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al crear eventos',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (ids) {
          add(GetEventsEvent(idShop: event.reserves.first.shopId!));
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<SearchGameByNameEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await searchGamesUseCase(event.gameName);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al realizar la búsqueda',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (games) {
          emit(
            ReserveSuccess(
              searchedGames: games,
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<GetLastTenPlayersEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await getLastTenPlayersUseCase(
        IdGoogleParams(googleId: event.idGoogle),
      );
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al obtener los últimos diez jugadores',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (players) {
          emit(
            ReserveSuccess(
              lastUsers: players,
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<UpdateReserveEvent>((event, emit) async {
      emit(
        ReserveLoading(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: state.filterTables,
        ),
      );
      final result = await updateReserveUseCase(event.reserve);
      result.fold(
        (failure) => emit(
          ReserveFailure(
            'Fallo al actualizar reserva',
            idReserve: state.idReserve,
            reserves: state.reserves,
            reserve: state.reserve,
            difficulties: state.difficulties,
            games: state.games,
            searchedGames: state.searchedGames,
            gameCategories: state.gameCategories,
            reservesOfUser: state.reservesOfUser,
            eventsShop: state.eventsShop,
            lastUsers: state.lastUsers,
            filterTables: state.filterTables,
          ),
        ),
        (_) {
          add(GetReservesByUserEvent(idUser: event.idUser));
          add(
            GetReserveByDateEvent(
              dateReserve: event.searchDateTime,
              idTable: event.reserve.tableId,
            ),
          );
          add(
            GetReserveWithUsers(
              idReserve: event.reserve.id,
            ),
          );
          emit(
            ReserveSuccess(
              idReserve: state.idReserve,
              reserves: state.reserves,
              reserve: state.reserve,
              difficulties: state.difficulties,
              games: state.games,
              searchedGames: state.searchedGames,
              gameCategories: state.gameCategories,
              reservesOfUser: state.reservesOfUser,
              eventsShop: state.eventsShop,
              lastUsers: state.lastUsers,
              filterTables: state.filterTables,
            ),
          );
        },
      );
    });

    on<ClearFilterEvent>((event, emit) async {
      emit(
        ReserveSuccess(
          idReserve: state.idReserve,
          reserves: state.reserves,
          reserve: state.reserve,
          difficulties: state.difficulties,
          games: state.games,
          searchedGames: state.searchedGames,
          gameCategories: state.gameCategories,
          reservesOfUser: state.reservesOfUser,
          eventsShop: state.eventsShop,
          lastUsers: state.lastUsers,
          filterTables: const {},
        ),
      );
    });
  }
}
