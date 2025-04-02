import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/game_datasource.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  GameRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override
/*************  ✨ Codeium Command ⭐  *************/
  /// Retrieves all games from the remote data source.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a list of [GameEntity]
  /// on the right if the operation is successful. If an error occurs, it resolves
  /// to the left with an [Exception].
  ///
  /// This function uses a token stored in shared preferences for authorization.

/******  114f9aa5-e5a4-494d-af34-b658c5cbdfd6  *******/
  Future<Either<Exception, List<GameEntity>>> getAllGames() async {
    try {
      final token = sharedPreferences.getString('token');
      final gameModels = await remoteDataSource.getAllGame(token!);
      return Right(gameModels.map((model) => model.toGameEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar juegos'));
    }
  }
  @override
  /// Searches for games by name.
  ///
  /// The [name] is the name of the game to search.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a list of [GameEntity]
  /// on the right if the operation is successful. If an error occurs, it resolves
  /// to the left with an [Exception].
  ///
  /// This function uses a token stored in shared preferences for authorization.
  Future<Either<Exception, List<GameEntity>>> searchGameByName(String name) async {
    try {
      final token = sharedPreferences.getString('token');
      final gameModels = await remoteDataSource.searchGameByName(token!, name);
      return Right(gameModels.map((model) => model.toGameEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al buscar juegos por nombre'));
    }
  }
}
