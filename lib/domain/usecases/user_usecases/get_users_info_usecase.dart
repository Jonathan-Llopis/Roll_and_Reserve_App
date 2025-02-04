import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';

class GetAllUsersUseCase
    implements UseCase<Either<Failure, List<UserEntity>>, NoParams> {
  final UserRespository repository;
  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async {
    return repository.getUsersInfo();
  }
}
