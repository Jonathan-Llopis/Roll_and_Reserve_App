import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import '../repositories/login_repository.dart';

class ResetPasswordUseCase {
  final LoginRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.resetPassword(email);
  }
}
