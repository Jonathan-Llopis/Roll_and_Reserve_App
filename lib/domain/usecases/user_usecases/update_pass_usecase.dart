import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import '../../repositories/user_repository.dart';

class UpdatePasswordUsecase {
  final UserRespository repository;

  UpdatePasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(String password, String oldPassword) async {
    return await repository.updatePassword(password, oldPassword);
  }
}
