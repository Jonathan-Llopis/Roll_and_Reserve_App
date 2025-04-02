import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/difficulty_datasource.dart';
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';
import 'package:roll_and_reserve/domain/repositories/difficulty_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DifficultyRepositoryImpl implements DifficultyRepository {
  final DifficultyRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  DifficultyRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override
  /// Gets all difficulties from the backend.
  ///
  /// Returns a [Future] that resolves to an [Either].
  /// If the request is successful, the [Either] is a [Right] containing a list of [DifficultyEntity].
  /// If the request fails, the [Either] is a [Left] containing an [Exception].
  ///
  /// The [Exception] is thrown if there is an error during the retrieval process.
  Future<Either<Exception, List<DifficultyEntity>>> getAllDifficultys() async {
    try {
      final token = sharedPreferences.getString('token');
      final difficultyModels = await remoteDataSource.getAllDifficulty(token!);
      return Right(difficultyModels.map((model) => model.toDifficultyEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar dificultades'));
    }
  }
}
