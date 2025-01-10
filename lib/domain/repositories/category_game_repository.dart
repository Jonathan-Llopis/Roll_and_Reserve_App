
import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';


abstract class CategoryGameRepository {
  Future<Either<Exception, List<GameCategoryEntity>>> getAllCategoryGames();

}