import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import '../../repositories/user_repository.dart';

class ValidatePasswordUsecase {
  final UserRespository repository;

  ValidatePasswordUsecase(this.repository);

  Future<Either<Failure, bool>> call(String password) async {
    return await repository.validatePassword(password);
  }
}
