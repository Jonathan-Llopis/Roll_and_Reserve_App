import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/category_games_datasource.dart';
import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';
import 'package:roll_and_reserve/domain/repositories/category_game_repository.dart';


import 'package:shared_preferences/shared_preferences.dart';

class CategoryGameRepositoryImpl implements CategoryGameRepository {
  final CategoryGameRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  CategoryGameRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override
  Future<Either<Exception, List<GameCategoryEntity>>> getAllCategoryGames() async {
    try {
      final token = sharedPreferences.getString('token');
      final categoryGameModels = await remoteDataSource.getAllCategoryGame(token!);
      return Right(categoryGameModels.map((model) => model.toGameCategoryEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar categorias de juego'));
    }
  }
}
