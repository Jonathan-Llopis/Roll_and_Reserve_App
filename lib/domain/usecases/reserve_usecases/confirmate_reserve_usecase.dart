import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class ConfirmateReserveUsecase implements UseCase<Either<Exception, bool>, IdReserveParams> {
  final ReserveRepository repository;
  ConfirmateReserveUsecase(this.repository);

  @override
   Future<Either<Exception, bool>> call(IdReserveParams params) async {
    return repository.confirmReserve(params.idReserve);
  }
}