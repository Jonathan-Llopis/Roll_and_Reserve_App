import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import '../../repositories/user_repository.dart';

class IsNameUsedUsecase {
  final UserRespository repository;

  IsNameUsedUsecase(this.repository);

  Future<Either<Failure, bool>> call(String email) async {
    return await repository.isNameUsed(email);
  }
}
