import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import '../../repositories/login_repository.dart';

class GetCurrentUserUseCase
    implements UseCase<Either<Failure, UserEntity>, NoParams> {
  final LoginRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return repository.isLoggedIn();
  }
}