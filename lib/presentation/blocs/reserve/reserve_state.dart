import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

class ReserveState {
  final bool isLoading;
  final int? idReserve;
  final String? errorMessage;
  final List<ReserveEntity>? reserves;
  final ReserveEntity? reserve;
  final List<DifficultyEntity>? difficulties;
  final List<GameEntity>? games;
  final List<GameCategoryEntity>? gameCategories;

  const ReserveState(
      {this.isLoading = false,
      this.idReserve,
      this.errorMessage,
      this.reserves,
      this.reserve,
      this.difficulties,
      this.games,
      this.gameCategories});

  ReserveState copyWith({
    bool? isLoading,
    int? idReserve,
    String? errorMessage,
    List<ReserveEntity>? reserves,
    ReserveEntity? reserve,
    List<DifficultyEntity>? difficulties,
    List<GameEntity>? games,
    List<GameCategoryEntity>? gameCategories,
  }) {
    return ReserveState(
        isLoading: isLoading ?? this.isLoading,
        idReserve: idReserve ?? this.idReserve,
        errorMessage: errorMessage ?? this.errorMessage,
        reserves: reserves ?? this.reserves,
        reserve: reserve ?? this.reserve,
        difficulties: difficulties ?? this.difficulties,
        games: games ?? this.games,
        gameCategories: gameCategories ?? this.gameCategories);
  }

  factory ReserveState.initial() => const ReserveState();

  factory ReserveState.loading() => const ReserveState(isLoading: true);

  factory ReserveState.success() => const ReserveState();

  factory ReserveState.getReserves(List<ReserveEntity> reserves) =>
      ReserveState(reserves: reserves);

  factory ReserveState.selectedReserve(ReserveEntity reserveSelected) =>
      ReserveState(reserve: reserveSelected);

  factory ReserveState.failure(String errorMessage) =>
      ReserveState(errorMessage: errorMessage);

  factory ReserveState.getDifficulties(List<DifficultyEntity> difficulties) =>
      ReserveState(difficulties: difficulties);

  factory ReserveState.getGames(List<GameEntity> games) =>
      ReserveState(games: games);

  factory ReserveState.getGameCategories(List<GameCategoryEntity> gameCategories) =>
      ReserveState(gameCategories: gameCategories);

    factory ReserveState.getAllData({
    required List<ReserveEntity> reserves,
    required List<GameEntity> games,
    required List<GameCategoryEntity> gameCategories,
    required List<DifficultyEntity> difficulties,
  }) {
    return ReserveState(
      isLoading: false,
      reserves: reserves,
      games: games,
      gameCategories: gameCategories,
      difficulties: difficulties,
    );
  }
}
