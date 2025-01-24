import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class GetAllReserveBydateUsecase implements UseCase<Either<Exception, List<ReserveEntity>>, GetReservesByDateUseCaseParams> {
  final ReserveRepository repository;
  GetAllReserveBydateUsecase(this.repository);

  @override
  Future<Either<Exception, List<ReserveEntity>>> call(GetReservesByDateUseCaseParams params) async {
    return repository.getAllReservesByDate(params.date, params.idTable);
  }
}