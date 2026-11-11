import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/repositories/category_game_repository.dart';

class GetAllCategoryGamesUseCase
    implements UseCase<Either<Failure, List<GameCategoryEntity>>, NoParams> {
  final CategoryGameRepository repository;
  GetAllCategoryGamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GameCategoryEntity>>> call(
    NoParams params,
  ) async {
    return repository.getAllCategoryGames();
  }
}
