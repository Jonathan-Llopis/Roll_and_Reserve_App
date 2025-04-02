import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/review_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/models/review_model.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final UserDatasource userDatasource;

  ReviewRepositoryImpl(this.remoteDataSource, this.sharedPreferences, this.userDatasource);

  @override
  /// Gets all reviews from the remote server.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a [List] of [ReviewEntity] if the request is successful.
  /// If the request fails, returns a [Left] containing an [Exception].
  Future<Either<Exception, List<ReviewEntity>>> getAllReviews() async {
    try {
      final token = sharedPreferences.getString('token');
      final reviewModels = await remoteDataSource.getAllReviews(token!);
      List<Future<dynamic>> avatarFiles = reviewModels.map((review) async {
        return await userDatasource.getUserAvatar(review.avatarIdWriter, token);
      }).toList();
      List<dynamic> avatars = await Future.wait(avatarFiles);
      List<ReviewEntity> reviewEntities = reviewModels.asMap().entries.map((entry) {
        return entry.value.toReviewEntity(avatars[entry.key]);
      }).toList();
      return Right(reviewEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reseñas'));
    }
  }

  @override
  /// Deletes a review from the remote server.
  ///
  /// The [idReview] is the id of the review to delete.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the review was deleted.
  /// Throws an [Exception] if there is an error during the deletion process.
  Future<Either<Exception, bool>> deleteReview(int idReview) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteReviews(idReview, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar el reseña'));
    }
  }

  @override
  /// Creates a new review in the remote server.
  ///
  /// The [review] is the [ReviewEntity] to create.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a boolean if the request is successful.
  /// If the status code is 201, returns true indicating the review was created.
  /// Throws an [Exception] if there is an error during the creation process.
  Future<Either<Exception, bool>> createReview(ReviewEntity review) async {
    try {
      final token = sharedPreferences.getString('token');
      ReviewModel shopModel = review.toReviewModel();
      await remoteDataSource.createReviews(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al crear el reseña: ${e.toString()}'));
    }
  }
  
}
