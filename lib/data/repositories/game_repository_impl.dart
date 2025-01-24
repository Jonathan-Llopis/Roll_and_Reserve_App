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
  Future<Either<Exception, List<GameEntity>>> getAllGames() async {
    try {
      final token = sharedPreferences.getString('token');
      final gameModels = await remoteDataSource.getAllGame(token!);
      return Right(gameModels.map((model) => model.toGameEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar juegos'));
    }
  }
}
