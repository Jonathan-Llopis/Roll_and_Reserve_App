import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class ReserveState {
  final bool isLoading;
  final int? idReserve;
  final String? errorMessage;
  final List<ReserveEntity>? reserves;
  final List<ReserveEntity>? reservesOfUser;
  final List<ReserveEntity>? eventsShop;
  final ReserveEntity? reserve;
  final List<DifficultyEntity>? difficulties;
  final List<GameEntity>? games;
  final List<GameEntity>? searchedGames;
  final List<GameCategoryEntity>? gameCategories;
  final List<UserEntity>? lastUsers;
  final Map<String, String>? filterTables;

  const ReserveState(
      {this.isLoading = false,
      this.idReserve,
      this.errorMessage,
      this.reserves,
      this.reserve,
      this.difficulties,
      this.games,
      this.searchedGames,
      this.gameCategories,
      this.reservesOfUser,
      this.eventsShop,
      this.lastUsers,
      this.filterTables});

  ReserveState copyWith({
    bool? isLoading,
    int? idReserve,
    String? errorMessage,
    List<ReserveEntity>? reserves,
    ReserveEntity? reserve,
    List<DifficultyEntity>? difficulties,
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? gameCategories,
    List<ReserveEntity>? reservesOfUser,
    List<ReserveEntity>? eventsShop,
    List<UserEntity>? lastUsers,
    Map<String, String>? filterTables,
  }) {
    return ReserveState(
        isLoading: isLoading ?? this.isLoading,
        idReserve: idReserve ?? this.idReserve,
        errorMessage: errorMessage,
        reserves: reserves ?? this.reserves,
        reserve: reserve ?? this.reserve,
        difficulties: difficulties ?? this.difficulties,
        games: games ?? this.games,
        searchedGames: searchedGames ?? this.searchedGames,
        gameCategories: gameCategories ?? this.gameCategories,
        reservesOfUser: reservesOfUser ?? this.reservesOfUser,
        eventsShop: eventsShop ?? this.eventsShop,
        lastUsers: lastUsers ?? this.lastUsers,
        filterTables: filterTables ?? this.filterTables);
  }

  factory ReserveState.initial() => const ReserveState();

  factory ReserveState.loading(ReserveState state) =>
      state.copyWith(isLoading: true, errorMessage: null);

  factory ReserveState.success(ReserveState state) =>
      state.copyWith(isLoading: false, errorMessage: null);

  factory ReserveState.getReserves(ReserveState state,
          List<ReserveEntity> reserves, Map<String, String> filterTables) =>
      state.copyWith(
          reserves: reserves,
          isLoading: false,
          errorMessage: null,
          filterTables: filterTables);

  factory ReserveState.getReserve(ReserveState state, ReserveEntity reserve) =>
      state.copyWith(reserve: reserve, isLoading: false, errorMessage: null);

  factory ReserveState.getEvents(ReserveState state, List<ReserveEntity> events,
          List<GameEntity> games) =>
      state.copyWith(
          eventsShop: events,
          isLoading: false,
          games: games,
          errorMessage: null);

  factory ReserveState.selectedReserve(
          ReserveState state, ReserveEntity reserveSelected) =>
      state.copyWith(
          reserve: reserveSelected, isLoading: false, errorMessage: null);

  factory ReserveState.failure(ReserveState state, String errorMessage) =>
      state.copyWith(errorMessage: errorMessage, isLoading: false);

  factory ReserveState.getDifficulties(
          ReserveState state, List<DifficultyEntity> difficulties) =>
      state.copyWith(
          difficulties: difficulties, isLoading: false, errorMessage: null);

  factory ReserveState.getGames(ReserveState state, List<GameEntity> games) =>
      state.copyWith(games: games, isLoading: false, errorMessage: null);

  factory ReserveState.getGameCategories(
          ReserveState state, List<GameCategoryEntity> gameCategories) =>
      state.copyWith(
          gameCategories: gameCategories, isLoading: false, errorMessage: null);

  factory ReserveState.getReservesOfUser(ReserveState state,
          List<ReserveEntity> reservesOfUser, List<GameEntity> games) =>
      state.copyWith(
          reservesOfUser: reservesOfUser,
          isLoading: false,
          games: games,
          errorMessage: null);
  factory ReserveState.searchGames(
          ReserveState state, List<GameEntity> searchedGames) =>
      state.copyWith(
          searchedGames: searchedGames, isLoading: false, errorMessage: null);

  factory ReserveState.getAllData({
    required ReserveState state,
    required List<ReserveEntity> reserves,
    required List<GameEntity> games,
    required List<GameCategoryEntity> gameCategories,
    required List<DifficultyEntity> difficulties,
  }) {
    return state.copyWith(
        isLoading: false,
        reserves: reserves,
        games: games,
        gameCategories: gameCategories,
        difficulties: difficulties,
        errorMessage: null);
  }

  factory ReserveState.getLastUsers(
          ReserveState state, List<UserEntity> lastUsers) =>
      state.copyWith(
          lastUsers: lastUsers, isLoading: false, errorMessage: null);
  factory ReserveState.clearFilter(ReserveState state) =>
      state.copyWith(filterTables: {});
}
