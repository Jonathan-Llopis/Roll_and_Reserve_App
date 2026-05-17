import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';

class SearchGamesUseCase
    implements UseCase<Either<Failure, List<GameEntity>>, String> {
  final GameRepository repository;

  SearchGamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GameEntity>>> call(String gameName) async {
    return repository.searchGameByName(gameName);
  }
}
