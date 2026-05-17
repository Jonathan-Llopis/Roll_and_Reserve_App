import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';

abstract class DifficultyRepository {
  Future<Either<Failure, List<DifficultyEntity>>> getAllDifficultys();
}
