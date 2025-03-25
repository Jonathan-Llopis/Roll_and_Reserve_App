import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
      this.updateReserveUseCase)
      : super(const ReserveState()) {
    on<GetReservesEvent>((event, emit) async {
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
            results[0] as Either<Exception, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Exception, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Exception, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Exception, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) =>
              emit(ReserveState.failure(state, "Error al cargar reservas")),
          (reserves) {
            categoriesResult.fold(
              (failure) => emit(ReserveState.failure(
                  state, "Error al cargar categorías de juegos")),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                      ReserveState.failure(state, "Error al cargar juegos")),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(ReserveState.failure(
                          state, "Error al cargar dificultades")),
                      (difficulties) {
                        emit(ReserveState.getAllData(
                          reserves: reserves,
                          games: games,
                          gameCategories: categories,
                          difficulties: difficulties,
                          state: state,
                        ));
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(ReserveState.failure(state, "Error inesperado: $e"));
      }
    });

    on<GetReserveEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await getReserveUseCase(NoParams());
      result.fold(
        (failure) => emit(
            ReserveState.failure(state, "Fallo al realizar la recuperacion")),
        (reservess) {
          final reserves = reservess
              .firstWhere((reserves) => reserves.id == event.idReserve);
          emit(ReserveState.selectedReserve(state, reserves));
          add(GetAllCategoryGameEvent());
          add(GetAllGameEvent());
          add(GetAllDifficultyEvent());
        },
      );
    });
    on<CreateReserveEvent>((event, emit) async {
      debugPrint('CreateReserveEvent, event: $event');
      emit(ReserveState.loading(
        state,
      ));
      final result = await createReserveUseCase(event.reserve);
      result.fold(
        (failure) =>
            emit(ReserveState.failure(state, "Fallo al crear reserva")),
        (id) {
          if (event.idUser != '') {
            add(AddUserToReserveEvent(
                idReserve: id,
                idUser: event.idUser,
                idTable: event.reserve.tableId,
                dateReserve: event.dateReserve,
                searchDateTime: event.dateReserve));
          }
          emit(
            ReserveState.success(
              state,
            ),
          );
        },
      );
    });
    on<DeleteReserveEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await deleteReserveUseCase(event.idReserve);
      result.fold(
        (failure) =>
            emit(ReserveState.failure(state, "Fallo al eliminar tienda")),
        (_) {
          emit(
            ReserveState.success(
              state,
            ),
          );
          add(GetReservesEvent());
        },
      );
    });
    on<GetAllDifficultyEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await getAllDifficultyUseCase(NoParams());
      result.fold(
        (failure) => emit(
            ReserveState.failure(state, "Fallo al realizar la recuperacion")),
        (dificulties) => emit(ReserveState.getDifficulties(state, dificulties)),
      );
    });
    on<GetAllGameEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await getAllGameUseCase(NoParams());
      result.fold(
        (failure) => emit(
            ReserveState.failure(state, "Fallo al realizar la recuperacion")),
        (games) => emit(ReserveState.getGames(state, games)),
      );
    });
    on<GetAllCategoryGameEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await getAllCategoryGamesUseCase(NoParams());
      result.fold(
        (failure) => emit(
            ReserveState.failure(state, "Fallo al realizar la recuperacion")),
        (categorygames) =>
            emit(ReserveState.getGameCategories(state, categorygames)),
      );
    });

    on<AddUserToReserveEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final params = UserToReserveUseCaseParams(
          idReserve: event.idReserve, idUser: event.idUser);
      final result = await addUserToReserveUseCase(params);
      result.fold(
        (failure) => emit(
          
            ReserveState.failure(state, "Fallo al agregar usuario a la mesa")),
        (_) {
           add(GetReserveByDateEvent(
              dateReserve: event.searchDateTime, idTable: event.idTable));
          add(GetReservesByUserEvent(idUser: event.idUser)); 
          add(GetReserveWithUsers(
            idReserve: event.idReserve,
          ));
         
          emit(
            ReserveState.success(
              state,
            ),
          );
        },
      );
    });
    on<DeleteUserOfReserveEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final params = UserToReserveUseCaseParams(
          idReserve: event.idReserve, idUser: event.idUser);
      final result = await deleteUserToReserveUseCase(params);
      result.fold(
        (failure) => emit(ReserveState.failure(
            state, "Fallo al eliminar usuario de la mesa")),
        (_) {
          add(GetReservesByUserEvent(idUser: event.idUser));
          add(GetReserveByDateEvent(
              dateReserve: event.dateReserve, idTable: event.idTable));
          add(GetReserveWithUsers(
            idReserve: event.idReserve,
          ));
          emit(
            ReserveState.success(
              state,
            ),
          );
        },
      );
    });
    on<GetReserveByTableEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));

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
            results[0] as Either<Exception, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Exception, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Exception, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Exception, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) =>
              emit(ReserveState.failure(state, "Error al cargar reservas")),
          (reserves) {
            categoriesResult.fold(
              (failure) => emit(ReserveState.failure(
                  state, "Error al cargar categorías de juegos")),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                      ReserveState.failure(state, "Error al cargar juegos")),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(ReserveState.failure(
                          state, "Error al cargar dificultades")),
                      (difficulties) {
                        final reservesByTable = reserves
                            .where(
                                (reserve) => reserve.tableId == event.idTable)
                            .toList();

                        emit(ReserveState.getAllData(
                          state: state,
                          reserves: reservesByTable,
                          games: games,
                          gameCategories: categories,
                          difficulties: difficulties,
                        ));
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(ReserveState.failure(state, "Error inesperado: $e"));
      }
    });
    on<GetReserveByDateEvent>((event, emit) async {
      try {
        debugPrint('GetReserveByDateEvent, date: ${event.dateReserve},');
        emit(ReserveState.loading(
          state,
        ));
        final reservesFuture =
            getAllReservesByDateUseCase(GetReservesByDateUseCaseParams(
          date: event.dateReserve,
          idTable: event.idTable,
        ));
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
            results[0] as Either<Exception, List<ReserveEntity>>;
        final categoriesResult =
            results[1] as Either<Exception, List<GameCategoryEntity>>;
        final gamesResult = results[2] as Either<Exception, List<GameEntity>>;
        final difficultiesResult =
            results[3] as Either<Exception, List<DifficultyEntity>>;

        reservesResult.fold(
          (failure) =>
              emit(ReserveState.failure(state, "Error al cargar reservas")),
          (reserves) {
            final filteredReserves = reserves
                .where((reserve) =>
                    reserve.dayDate ==
                        DateFormat('dd - MM - yyyy')
                            .format(event.dateReserve) &&
                    reserve.tableId == event.idTable)
                .toList();

            categoriesResult.fold(
              (failure) => emit(ReserveState.failure(
                  state, "Error al cargar categorías de juegos")),
              (categories) {
                gamesResult.fold(
                  (failure) => emit(
                      ReserveState.failure(state, "Error al cargar juegos")),
                  (games) {
                    difficultiesResult.fold(
                      (failure) => emit(ReserveState.failure(
                          state, "Error al cargar dificultades")),
                      (difficulties) {
                        emit(ReserveState.getAllData(
                          state: state,
                          reserves: filteredReserves,
                          games: games,
                          gameCategories: categories,
                          difficulties: difficulties,
                        ));
                      },
                    );
                  },
                );
              },
            );
          },
        );
      } catch (e) {
        emit(ReserveState.failure(state, "Error inesperado: $e"));
      }
    });

    on<GetReservesByShopEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));

      try {
        final reservesFuture = getReserveUseCase(NoParams());
        final results = await reservesFuture;
        final reservesResult = results;

        reservesResult.fold(
          (failure) =>
              emit(ReserveState.failure(state, "Error al cargar reservas")),
          (reserves) {
            final reservesByShop = reserves
                .where((reserve) =>
                    event.currentShop.tablesShop.contains(reserve.tableId))
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

            emit(ReserveState.getReserves(state, filteredReserves, filterTables));
          },
        );
      } catch (e) {
        emit(ReserveState.failure(state, "Error inesperado: $e"));
      }
    });
    on<GetReserveWithUsers>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await getReserveWithuserUsecase(
          IdReserveParams(idReserve: event.idReserve));
      result.fold(
        (failure) => emit(ReserveState.failure(
            state, "Fallo al obtener reservas del usuario")),
        (reserves) => emit(ReserveState.getReserve(state, reserves)),
      );
    });
    on<GetReservesByUserEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final reservesFuture = getReservesOfUserUseCase(
          GetReserveFromUsersUseCaseParams(idUser: event.idUser));
      final gamesFuture = getAllGameUseCase(NoParams());

      final results = await Future.wait([
        reservesFuture,
        gamesFuture,
      ]);

      final reservesResult =
          results[0] as Either<Exception, List<ReserveEntity>>;
      final gamesResult = results[1] as Either<Exception, List<GameEntity>>;

      reservesResult.fold(
        (failure) => emit(ReserveState.failure(
            state, "Fallo al obtener reservas del usuario")),
        (reserves) {
          gamesResult.fold(
            (failure) =>
                emit(ReserveState.failure(state, "Error al cargar juegos")),
            (games) {
              emit(ReserveState.getReservesOfUser(state, reserves, games));
            },
          );
        },
      );
    });
    on<ConfirmReserveEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await confirmateReserveUsecase(
          IdReserveParams(idReserve: event.idReserve));
      result.fold(
        (failure) =>
            emit(ReserveState.failure(state, "Fallo al confirmar reserva")),
        (_) {
          emit(ReserveState.success(state));
          add(GetReserveWithUsers(
            idReserve: event.idReserve,
          ));
        },
      );
    });
    on<GetEventsEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final eventsFuture =
          getEventsShopUsecase(GetEventsParams(idShop: event.idShop));
      final gamesFuture = getAllGameUseCase(NoParams());

      final results = await Future.wait([
        eventsFuture,
        gamesFuture,
      ]);

      final eventsResult = results[0] as Either<Exception, List<ReserveEntity>>;
      final gamesResult = results[1] as Either<Exception, List<GameEntity>>;

      eventsResult.fold(
        (failure) =>
            emit(ReserveState.failure(state, "Fallo al obtener eventos")),
        (events) {
          gamesResult.fold(
            (failure) =>
                emit(ReserveState.failure(state, "Error al cargar juegos")),
            (games) {
              emit(ReserveState.getEvents(state, events, games));
            },
          );
        },
      );
    });

    on<CreateEventsEvent>((event, emit) async {
      emit(ReserveState.loading(
        state,
      ));
      final result = await createEventsUsecase(event.reserves);
      result.fold(
        (failure) =>
            emit(ReserveState.failure(state, "Fallo al crear eventos")),
        (ids) {
          add(GetEventsEvent(idShop: event.reserves.first.shopId!));
          emit(ReserveState.success(state));
        },
      );
    });
    on<SearchGameByNameEvent>((event, emit) async {
      emit(ReserveState.loading(
      state,
      ));
      final result = await searchGamesUseCase(event.gameName);
      result.fold(
      (failure) => emit(
        ReserveState.failure(state, "Fallo al realizar la búsqueda")),
      (games) {
        emit(ReserveState.searchGames(state, games));
      },
      );
    });
    on<GetLastTenPlayersEvent>((event, emit) async {
    emit(ReserveState.loading(
      state,
    ));
    final result = await getLastTenPlayersUseCase(IdGoogleParams(googleId: event.idGoogle));
    result.fold(
      (failure) => emit(
          ReserveState.failure(state, "Fallo al obtener los últimos diez jugadores")),
      (players) {
        emit(ReserveState.getLastUsers(state, players));
      },
    );
  });
  on<UpdateReserveEvent>((event, emit) async {
    emit(ReserveState.loading(
      state,
    ));
    final result = await updateReserveUseCase(event.reserve);
    result.fold(
      (failure) => emit(ReserveState.failure(state, "Fallo al actualizar reserva")),
     (_) {
          add(GetReservesByUserEvent(idUser: event.idUser));
          add(GetReserveByDateEvent(
              dateReserve: event.searchDateTime, idTable: event.reserve.tableId));
          add(GetReserveWithUsers(
            idReserve: event.reserve.id,
          ));
          emit(
            ReserveState.success(
              state,
            ),
          );
        },
    );
  });
  on<ClearFilterEvent>((event, emit) async {
    emit(ReserveState.clearFilter(
      state,
    ));
  });
  }
}
