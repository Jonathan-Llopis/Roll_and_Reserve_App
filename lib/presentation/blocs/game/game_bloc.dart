import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_categories_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_difficulties_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/get_all_games_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/game_usecases/search_games_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_event.dart';
import 'package:roll_and_reserve/presentation/blocs/game/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GetAllGameUseCase getAllGameUseCase;
  final GetAllCategoryGamesUseCase getAllCategoryGamesUseCase;
  final GetAllDifficultyUseCase getAllDifficultyUseCase;
  final SearchGamesUseCase searchGamesUseCase;

  GameBloc({
    required this.getAllGameUseCase,
    required this.getAllCategoryGamesUseCase,
    required this.getAllDifficultyUseCase,
    required this.searchGamesUseCase,
  }) : super(const GameInitial()) {
    on<GetAllGamesEvent>(_onGetAllGames);
    on<GetAllCategoriesEvent>(_onGetAllCategories);
    on<GetAllDifficultiesEvent>(_onGetAllDifficulties);
    on<SearchGameByNameEvent>(_onSearchGameByName);
  }

  Future<void> _onGetAllGames(
    GetAllGamesEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(
      GameLoading(
        games: state.games,
        searchedGames: state.searchedGames,
        categories: state.categories,
        difficulties: state.difficulties,
      ),
    );
    final result = await getAllGameUseCase(NoParams());
    result.fold(
      (failure) => emit(
        GameFailure(
          failure.message,
          games: state.games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
      (games) => emit(
        GameLoaded(
          games: games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
    );
  }

  Future<void> _onGetAllCategories(
    GetAllCategoriesEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(
      GameLoading(
        games: state.games,
        searchedGames: state.searchedGames,
        categories: state.categories,
        difficulties: state.difficulties,
      ),
    );
    final result = await getAllCategoryGamesUseCase(NoParams());
    result.fold(
      (failure) => emit(
        GameFailure(
          failure.message,
          games: state.games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
      (categories) => emit(
        GameLoaded(
          games: state.games,
          searchedGames: state.searchedGames,
          categories: categories,
          difficulties: state.difficulties,
        ),
      ),
    );
  }

  Future<void> _onGetAllDifficulties(
    GetAllDifficultiesEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(
      GameLoading(
        games: state.games,
        searchedGames: state.searchedGames,
        categories: state.categories,
        difficulties: state.difficulties,
      ),
    );
    final result = await getAllDifficultyUseCase(NoParams());
    result.fold(
      (failure) => emit(
        GameFailure(
          failure.message,
          games: state.games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
      (difficulties) => emit(
        GameLoaded(
          games: state.games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: difficulties,
        ),
      ),
    );
  }

  Future<void> _onSearchGameByName(
    SearchGameByNameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(
      GameLoading(
        games: state.games,
        searchedGames: state.searchedGames,
        categories: state.categories,
        difficulties: state.difficulties,
      ),
    );
    final result = await searchGamesUseCase(event.gameName);
    result.fold(
      (failure) => emit(
        GameFailure(
          failure.message,
          games: state.games,
          searchedGames: state.searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
      (searchedGames) => emit(
        GameLoaded(
          games: state.games,
          searchedGames: searchedGames,
          categories: state.categories,
          difficulties: state.difficulties,
        ),
      ),
    );
  }
}
