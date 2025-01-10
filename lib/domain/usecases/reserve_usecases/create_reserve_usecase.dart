import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class CreateReserveUseCase implements UseCase<Either<Exception, int>, ReserveEntity> {
  final ReserveRepository repository;
  CreateReserveUseCase(this.repository);

  @override
  Future<Either<Exception, int>> call(ReserveEntity reserve) async {
    return repository.createReserve(reserve);
  }
}