import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/review_datasource.dart';
import 'package:roll_and_reserve/data/models/review_model.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  ReviewRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override
  Future<Either<Exception, List<ReviewEntity>>> getAllReviews() async {
    try {
      final token = sharedPreferences.getString('token');
      final reviewModels = await remoteDataSource.getAllReviews(token!);
      return Right(reviewModels.map((model) => model.toReviewEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar review'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteReview(int idReview) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteReviews(idReview, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar el review'));
    }
  }

  @override
  Future<Either<Exception, bool>> createReview(ReviewEntity review) async {
    try {
      final token = sharedPreferences.getString('token');
      ReviewModel shopModel = review.toReviewModel();
      await remoteDataSource.createReviews(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al crear el review: ${e.toString()}'));
    }
  }
}
