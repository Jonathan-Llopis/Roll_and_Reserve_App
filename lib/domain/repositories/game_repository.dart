import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/entities/genui_component_entity.dart';

abstract class GameRepository {
  Future<Either<Failure, List<GameEntity>>> getAllGames();
  Future<Either<Failure, List<GameEntity>>> searchGameByName(String name);
  Future<Either<Failure, RulesAssistResponseEntity>> askGameRule({
    required String question,
    int? gameId,
    int? bggId,
    String? gameName,
    List<Map<String, String>>? history,
  });
}
