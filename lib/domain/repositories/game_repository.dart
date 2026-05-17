import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';

abstract class GameRepository {
  Future<Either<Failure, List<GameEntity>>> getAllGames();
  Future<Either<Failure, List<GameEntity>>> searchGameByName(String name);
}
