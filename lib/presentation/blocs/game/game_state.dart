import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';

sealed class GameState extends Equatable {
  final List<GameEntity>? games;
  final List<GameEntity>? searchedGames;
  final List<GameCategoryEntity>? categories;
  final List<DifficultyEntity>? difficulties;

  const GameState({
    this.games,
    this.searchedGames,
    this.categories,
    this.difficulties,
  });

  bool get isLoading => this is GameLoading;
  String? get errorMessage =>
      this is GameFailure ? (this as GameFailure).message : null;

  GameState copyWith({
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? categories,
    List<DifficultyEntity>? difficulties,
  });

  @override
  List<Object?> get props => [
        games,
        searchedGames,
        categories,
        difficulties,
      ];
}

class GameInitial extends GameState {
  const GameInitial() : super();

  @override
  GameState copyWith({
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? categories,
    List<DifficultyEntity>? difficulties,
  }) {
    return GameLoaded(
      games: games ?? this.games,
      searchedGames: searchedGames ?? this.searchedGames,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
    );
  }
}

class GameLoading extends GameState {
  const GameLoading({
    super.games,
    super.searchedGames,
    super.categories,
    super.difficulties,
  });

  @override
  GameState copyWith({
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? categories,
    List<DifficultyEntity>? difficulties,
  }) {
    return GameLoading(
      games: games ?? this.games,
      searchedGames: searchedGames ?? this.searchedGames,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
    );
  }
}

class GameLoaded extends GameState {
  const GameLoaded({
    super.games,
    super.searchedGames,
    super.categories,
    super.difficulties,
  });

  @override
  GameState copyWith({
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? categories,
    List<DifficultyEntity>? difficulties,
  }) {
    return GameLoaded(
      games: games ?? this.games,
      searchedGames: searchedGames ?? this.searchedGames,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
    );
  }
}

class GameFailure extends GameState {
  final String message;

  const GameFailure(
    this.message, {
    super.games,
    super.searchedGames,
    super.categories,
    super.difficulties,
  });

  @override
  GameState copyWith({
    List<GameEntity>? games,
    List<GameEntity>? searchedGames,
    List<GameCategoryEntity>? categories,
    List<DifficultyEntity>? difficulties,
  }) {
    return GameFailure(
      message,
      games: games ?? this.games,
      searchedGames: searchedGames ?? this.searchedGames,
      categories: categories ?? this.categories,
      difficulties: difficulties ?? this.difficulties,
    );
  }

  @override
  List<Object?> get props => [...super.props, message];
}
