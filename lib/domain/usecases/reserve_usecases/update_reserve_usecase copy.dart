import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class UpdateReserveUseCase implements UseCase<Either<Exception, bool>, ReserveEntity> {
  final ReserveRepository repository;
  UpdateReserveUseCase(this.repository);

  @override
  Future<Either<Exception, bool>> call(ReserveEntity table) async {
    return repository.updateReserve(table);
  }
}
