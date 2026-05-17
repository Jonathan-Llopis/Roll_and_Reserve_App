import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/review_entity.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';

class GetAllReviewUseCase
    implements UseCase<Either<Failure, List<ReviewEntity>>, NoParams> {
  final ReviewRepository repository;
  GetAllReviewUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(NoParams params) async {
    return repository.getAllReviews();
  }
}
