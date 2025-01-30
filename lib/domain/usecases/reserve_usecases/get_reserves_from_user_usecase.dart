import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';


class GetReservesFromUserUseCase implements UseCase<Either<Exception, List<ReserveEntity>>, GetReserveFromUsersUseCaseParams> {
  final ReserveRepository repository;
  GetReservesFromUserUseCase(this.repository);

  @override
  Future<Either<Exception, List<ReserveEntity>>> call(GetReserveFromUsersUseCaseParams params) async {
    return await repository.getReservesOfUser(params.idUser);
  }
}