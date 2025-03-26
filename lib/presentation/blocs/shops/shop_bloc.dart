import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
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
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final CreateShopsUseCase createShopsUseCase;
  final GetAllShopsUseCase getShopsUseCase;
  final UpdateShopsUseCase updateShopsUseCase;
  final DeleteShopsUseCase deleteShopsUseCase;
  final GetShopUseCase getShopUseCase;
  final GetAllShopsByOwnerUseCase getAllShopsByOwnerUseCase;
  final GetMostPlayedGamesUseCase getMostPlayedGames;
  final GetTotalReservationsUseCase getTotalReservations;
  final GetPlayerCountUseCase getPlayerCount;
  final GetPeakReservationHoursUseCase getPeakReservationHours;

  ShopBloc(
      this.createShopsUseCase,
      this.getShopsUseCase,
      this.updateShopsUseCase,
      this.deleteShopsUseCase,
      this.getShopUseCase,
      this.getAllShopsByOwnerUseCase,
      this.getMostPlayedGames,
      this.getTotalReservations,
      this.getPlayerCount,
      this.getPeakReservationHours)
      : super(const ShopState()) {
    on<GetShopsEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await getShopsUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ShopState.failure(state, "Fallo al realizar la recuperacion")),
        (shops) => emit(ShopState.getShops(state, shops)),
      );
    });

    on<GetShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result =
          await getShopUseCase(GetShopUseCaseParams(idShop: event.idShop));
      result.fold(
        (failure) =>
            emit(ShopState.failure(state, "Fallo al realizar la recuperacion")),
        (shop) {
          emit(ShopState.selectedShop(state, shop));
        },
      );
    });
    on<CreateShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await createShopsUseCase(event.shop);
      result.fold(
        (failure) => emit(ShopState.failure(state, "Fallo al crear tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsByOwnerEvent(owner: event.shop.ownerId));
        },
      );
    });
    on<UpdateShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await updateShopsUseCase(event.shop);
      result.fold(
        (failure) =>
            emit(ShopState.failure(state, "Fallo al actualizar tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsEvent());
          add(GetShopsByOwnerEvent(owner: event.shop.ownerId));
        },
      );
    });
    on<DeleteShopEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final result = await deleteShopsUseCase(event.idShop);
      result.fold(
        (failure) => emit(ShopState.failure(state, "Fallo al eliminar tienda")),
        (_) {
          emit(
            ShopState.success(state),
          );
          add(GetShopsByOwnerEvent(owner: event.idOwner));
        },
      );
    });
    on<GetShopsByOwnerEvent>((event, emit) async {
      emit(ShopState.loading(
        state,
      ));
      final result = await getAllShopsByOwnerUseCase(
          GetShopsByOwnerUseCaseParams(idOwner: event.owner));
      result.fold(
        (failure) =>
            emit(ShopState.failure(state, "Fallo al realizar la recuperacion")),
        (shopsByOwner) {
          emit(ShopState.getShops(state, shopsByOwner));
        },
      );
    });
    on<GetShopByFilterEvent>((event, emit) async {
      emit(ShopState.loading(
        state,
      ));
      final result = await getShopsUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(ShopState.failure(state, "Falló al realizar la recuperación")),
        (shops) {
          final filteredShops = shops.where((shop) {
            if (event.name != null && event.name!.isNotEmpty) {
              if (!shop.name
                  .toLowerCase()
                  .contains(event.name!.toLowerCase())) {
                return false;
              }
            }
            if (event.direction != null && event.direction!.isNotEmpty) {
              if (!shop.address
                  .toLowerCase()
                  .contains(event.direction!.toLowerCase())) {
                return false;
              }
            }
            return true;
          });
          final Map<String, String> filterShops = {
            if (event.name != null && event.name!.isNotEmpty)
              'name': event.name!,
            if (event.direction != null && event.direction!.isNotEmpty)
              'direction': event.direction!,
          };
          emit(ShopState.filterShops(
              state, filterShops, filteredShops.toList()));
        },
      );
    });
    on<ClearFilterEvent>((event, emit) async {
      emit(ShopState.clearFilter(state));
    });

    on<GetMostPlayedGamesEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final Map<String, dynamic> mostPlayedGames = {};

      final periods = {
        'Month': 30,
        'Quarter': 90,
        'Year': 365,
      };

      for (var period in periods.entries) {
        final result = await getMostPlayedGames(StadisticsParams(
          idShop: event.idShop,
          startTime:
              DateTime.now().subtract(Duration(days: period.value)).toString(),
          endTime: DateTime.now().toString(),
        ));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener los juegos más jugados del último ${period.key.toLowerCase()}")),
          (games) => mostPlayedGames[period.key] = games,
        );
      }

      emit(ShopState.mostPlayedGames(state, mostPlayedGames));
    });

    on<GetTotalReservationsEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final Map<String, dynamic> totalReservations = {};

      final Map<String, int> monthReservations = {};
      for (int i = 0; i < 30; i++) {
        final now = DateTime.now();
        final date = now.subtract(Duration(days: i));
        final startTime = DateTime(date.year, date.month, date.day).toString();
        final endTime =
            DateTime(date.year, date.month, date.day + 1).toString();
        final result = await getTotalReservations(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el total de reservas para el día ${date.day}")),
          (reservations) =>
              monthReservations['${date.day}/${date.month}'] = reservations,
        );
      }
      final reversedMonthReservations = Map.fromEntries(
        monthReservations.entries.toList().reversed,
      );
      totalReservations['Month'] = reversedMonthReservations;

      final Map<String, int> quarterReservations = {};
      for (int i = 0; i < 6; i++) {
        final now = DateTime.now();
        final startDate = now.subtract(Duration(days: i * 15));
        final endDate = now.subtract(Duration(days: (i * 15) - 15));
        final startTime =
            DateTime(startDate.year, startDate.month, startDate.day).toString();
        final endTime =
            DateTime(endDate.year, endDate.month, endDate.day).toString();
        final result = await getTotalReservations(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el total de reservas para el periodo del ${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}")),
          (reservations) => quarterReservations[
                  '${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}'] =
              reservations,
        );
      }
      final reversedQuarterReservations = Map.fromEntries(
        quarterReservations.entries.toList().reversed,
      );
      totalReservations['Quarter'] = reversedQuarterReservations;

      final Map<String, int> yearReservations = {};
      for (int i = 0; i < 12; i++) {
        final now = DateTime.now();
        final startMonth = (now.month - i) % 12;
        final startTime =
            DateTime(now.year, startMonth > 0 ? startMonth : 12 + startMonth, 1)
                .toString();
        final endMonth = (now.month - i + 1) % 12;
        final endTime =
            DateTime(now.year, endMonth > 0 ? endMonth : 12 + endMonth, 1)
                .toString();
        final result = await getTotalReservations(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el total de reservas para el mes ${(now.month - i - 1) % 12}")),
          (reservations) =>
              yearReservations[((now.month - i - 1) % 12).toString()] =
                  reservations,
        );
      }
      final reversedYearReservations = Map.fromEntries(
        yearReservations.entries.toList().reversed,
      );
      totalReservations['Year'] = reversedYearReservations;

      emit(ShopState.totalReservations(state, totalReservations));
    });

    on<GetPlayerCountEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final Map<String, dynamic> playerCounts = {};
      final Map<String, int> monthPlayerCounts = {};
      for (int i = 0; i < 30; i++) {
        final now = DateTime.now();
        final date = now.subtract(Duration(days: i));
        final startTime = DateTime(date.year, date.month, date.day).toString();
        final endTime =
            DateTime(date.year, date.month, date.day + 1).toString();
        final result = await getPlayerCount(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el conteo de jugadores para el día ${date.day}")),
          (playerCount) =>
              monthPlayerCounts['${date.day}/${date.month}'] = playerCount,
        );
      }
      final reversedMonthPlayerCounts = Map.fromEntries(
        monthPlayerCounts.entries.toList().reversed,
      );
      playerCounts['Month'] = reversedMonthPlayerCounts;

      final Map<String, int> quarterPlayerCounts = {};
      for (int i = 0; i < 6; i++) {
        final now = DateTime.now();
        final startDate = now.subtract(Duration(days: i * 15));
        final endDate = now.subtract(Duration(days: (i * 15) - 15));
        final startTime =
            DateTime(startDate.year, startDate.month, startDate.day).toString();
        final endTime =
            DateTime(endDate.year, endDate.month, endDate.day).toString();
        final result = await getPlayerCount(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el conteo de jugadores para el periodo del ${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}")),
          (playerCount) => quarterPlayerCounts[
                  '${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}'] =
              playerCount,
        );
      }
      final reversedQuarterPlayerCounts = Map.fromEntries(
        quarterPlayerCounts.entries.toList().reversed,
      );
      playerCounts['Quarter'] = reversedQuarterPlayerCounts;

      final Map<String, int> yearPlayerCounts = {};
      for (int i = 0; i < 12; i++) {
        final now = DateTime.now();
        final startMonth = (now.month - i) % 12;
        final startTime =
            DateTime(now.year, startMonth > 0 ? startMonth : 12 + startMonth, 1)
                .toString();
        final endMonth = (now.month - i + 1) % 12;
        final endTime =
            DateTime(now.year, endMonth > 0 ? endMonth : 12 + endMonth, 1)
                .toString();
        final result = await getPlayerCount(StadisticsParams(
            idShop: event.idShop, startTime: startTime, endTime: endTime));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener el conteo de jugadores para el mes ${(now.month - i - 1) % 12}")),
          (playerCount) =>
              yearPlayerCounts[((now.month - i - 1) % 12).toString()] =
                  playerCount,
        );
      }
      final reversedYearPlayerCounts = Map.fromEntries(
        yearPlayerCounts.entries.toList().reversed,
      );
      playerCounts['Year'] = reversedYearPlayerCounts;

      emit(ShopState.playerCount(state, playerCounts));
    });

    on<GetPeakReservationHoursEvent>((event, emit) async {
      emit(ShopState.loading(state));
      final Map<String, dynamic> peakReservationHours = {};

      final periods = {
        'Month': 30,
        'Quarter': 90,
        'Year': 365,
      };

      for (var period in periods.entries) {
        final result = await getPeakReservationHours(StadisticsParams(
          idShop: event.idShop,
          startTime:
              DateTime.now().subtract(Duration(days: period.value)).toString(),
          endTime: DateTime.now().toString(),
        ));
        result.fold(
          (failure) => emit(ShopState.failure(state,
              "Fallo al obtener las horas pico de reservas del último ${period.key.toLowerCase()}")),
          (hours) => peakReservationHours[period.key] = hours,
        );
      }

      emit(ShopState.peakReservationHours(state, peakReservationHours));
    });
  }
}
