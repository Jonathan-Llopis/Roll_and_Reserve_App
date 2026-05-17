import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

sealed class ReserveState extends Equatable {
  final int? idReserve;
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

  const ReserveState({
    this.idReserve,
    this.reserves,
    this.reserve,
    this.difficulties,
    this.games,
    this.searchedGames,
    this.gameCategories,
    this.reservesOfUser,
    this.eventsShop,
    this.lastUsers,
    this.filterTables,
  });

  bool get isLoading => this is ReserveLoading;
  String? get errorMessage =>
      this is ReserveFailure ? (this as ReserveFailure).message : null;

  @override
  List<Object?> get props => [
        idReserve,
        reserves,
        reserve,
        difficulties,
        games,
        searchedGames,
        gameCategories,
        reservesOfUser,
        eventsShop,
        lastUsers,
        filterTables,
      ];
}

class ReserveInitial extends ReserveState {
  const ReserveInitial() : super();
}

class ReserveLoading extends ReserveState {
  const ReserveLoading({
    super.idReserve,
    super.reserves,
    super.reserve,
    super.difficulties,
    super.games,
    super.searchedGames,
    super.gameCategories,
    super.reservesOfUser,
    super.eventsShop,
    super.lastUsers,
    super.filterTables,
  });
}

class ReserveSuccess extends ReserveState {
  const ReserveSuccess({
    super.idReserve,
    super.reserves,
    super.reserve,
    super.difficulties,
    super.games,
    super.searchedGames,
    super.gameCategories,
    super.reservesOfUser,
    super.eventsShop,
    super.lastUsers,
    super.filterTables,
  });
}

class ReserveFailure extends ReserveState {
  final String message;
  const ReserveFailure(
    this.message, {
    super.idReserve,
    super.reserves,
    super.reserve,
    super.difficulties,
    super.games,
    super.searchedGames,
    super.gameCategories,
    super.reservesOfUser,
    super.eventsShop,
    super.lastUsers,
    super.filterTables,
  });

  @override
  List<Object?> get props => [super.props, message];
}
