import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class GetReserveWithuserUsecase implements UseCase<Either<Exception, ReserveEntity>, GetReserveWithUsersUseCaseParams> {
  final ReserveRepository repository;
  GetReserveWithuserUsecase(this.repository);

  @override
  Future<Either<Exception, ReserveEntity>> call(GetReserveWithUsersUseCaseParams params) async {
    return repository.getReserveWithUsers(params.idReserve);
  }
}