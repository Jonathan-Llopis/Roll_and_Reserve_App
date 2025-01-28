import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class CreateEventsUsecase implements UseCase<Either<Exception, List<int>>, List<ReserveEntity>> {
  final ReserveRepository repository;
  CreateEventsUsecase(this.repository);

  @override
  Future<Either<Exception, List<int>>> call(List<ReserveEntity> reserve) async {
    return repository.createMultipleReservesEvent(reserve);
  }
}