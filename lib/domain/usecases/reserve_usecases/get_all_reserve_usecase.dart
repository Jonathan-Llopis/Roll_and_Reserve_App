import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class GetAllReservesUseCase
    implements UseCase<Either<Failure, List<ReserveEntity>>, NoParams> {
  final ReserveRepository repository;
  GetAllReservesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReserveEntity>>> call(NoParams params) async {
    return repository.getAllReserves();
  }
}
