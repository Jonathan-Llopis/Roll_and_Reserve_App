import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/repositories/difficulty_repository.dart';


class GetAllDifficultyUseCase implements UseCase<Either<Exception, List<DifficultyEntity>>, NoParams> {
  final DifficultyRepository repository;
  GetAllDifficultyUseCase(this.repository);

  @override
  Future<Either<Exception, List<DifficultyEntity>>> call(NoParams params) async {
    return repository.getAllDifficultys();
  }
}