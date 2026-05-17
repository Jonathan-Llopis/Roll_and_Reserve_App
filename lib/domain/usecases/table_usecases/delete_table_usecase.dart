import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';

class DeleteTableUseCase implements UseCase<Either<Failure, bool>, int> {
  final TableRepository repository;
  DeleteTableUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(int idTable) async {
    return repository.deleteTable(idTable);
  }
}
