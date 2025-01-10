import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class DeleteReserveUseCase implements UseCase<Either<Exception, bool>, int> {
  final ReserveRepository repository;
  DeleteReserveUseCase(this.repository);

  @override
  Future<Either<Exception, bool>> call(int idReserve) async {
    return repository.deleteReserve(idReserve);
  }
}