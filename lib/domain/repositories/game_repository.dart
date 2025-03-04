import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';


abstract class GameRepository {
  Future<Either<Exception, List<GameEntity>>> getAllGames();
  Future<Either<Exception, List<GameEntity>>> searchGameByName(String name);
}