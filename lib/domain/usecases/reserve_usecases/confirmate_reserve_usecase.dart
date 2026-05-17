import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class ConfirmateReserveUsecase
    implements UseCase<Either<Failure, bool>, IdReserveParams> {
  final ReserveRepository repository;
  ConfirmateReserveUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IdReserveParams params) async {
    return repository.confirmReserve(params.idReserve);
  }
}
