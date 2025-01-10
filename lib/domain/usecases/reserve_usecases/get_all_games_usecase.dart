import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/game_entity.dart';
import 'package:roll_and_reserve/domain/repositories/game_repository.dart';

class GetAllGameUseCase implements UseCase<Either<Exception, List<GameEntity>>, NoParams> {
  final GameRepository repository;
  GetAllGameUseCase(this.repository);

  @override
  Future<Either<Exception, List<GameEntity>>> call(NoParams params) async {
    return repository.getAllGames();
  }
}