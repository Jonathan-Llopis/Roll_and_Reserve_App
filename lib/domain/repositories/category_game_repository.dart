import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';

abstract class CategoryGameRepository {
  Future<Either<Failure, List<GameCategoryEntity>>> getAllCategoryGames();
}
