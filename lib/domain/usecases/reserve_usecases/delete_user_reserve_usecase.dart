import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class DeleteUserOfReserveUseCase
    implements UseCase<Either<Failure, bool>, UserToReserveUseCaseParams> {
  final ReserveRepository repository;
  DeleteUserOfReserveUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UserToReserveUseCaseParams params) async {
    return repository.deleteUserOfReserve(params.idReserve, params.idUser);
  }
}
