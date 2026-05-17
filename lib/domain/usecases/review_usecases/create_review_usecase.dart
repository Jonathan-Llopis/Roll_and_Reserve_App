import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';

class CreateReviewUseCase
    implements UseCase<Either<Failure, bool>, ReviewEntity> {
  final ReviewRepository repository;
  CreateReviewUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReviewEntity review) async {
    return repository.createReview(review);
  }
}
