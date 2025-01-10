import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<Either<Exception, List<ReviewEntity>>> getAllReviews();
  Future<Either<Exception, bool>> deleteReview(int idReview);
  Future<Either<Exception, bool>> createReview(ReviewEntity review);

}