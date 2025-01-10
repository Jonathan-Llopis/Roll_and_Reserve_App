import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class GetAllReservesUseCase implements UseCase<Either<Exception, List<ReserveEntity>>, NoParams> {
  final ReserveRepository repository;
  GetAllReservesUseCase(this.repository);

  @override
  Future<Either<Exception, List<ReserveEntity>>> call(NoParams params) async {
    return repository.getAllReserves();
  }
}