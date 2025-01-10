import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/review_repository.dart';


class DeleteReviewUseCase implements UseCase<Either<Exception, bool>, int> {
  final ReviewRepository repository;
  DeleteReviewUseCase(this.repository);

  @override
  Future<Either<Exception, bool>> call(int idReview) async {
    return repository.deleteReview(idReview);
  }
}