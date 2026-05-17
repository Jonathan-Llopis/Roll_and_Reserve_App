import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getAllReviews();
  Future<Either<Failure, bool>> deleteReview(int idReview);
  Future<Either<Failure, bool>> createReview(ReviewEntity review);
}
