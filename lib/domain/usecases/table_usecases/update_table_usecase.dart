import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';

class UpdateTableUseCase
    implements UseCase<Either<Failure, bool>, TableEntity> {
  final TableRepository repository;
  UpdateTableUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(TableEntity table) async {
    return repository.updateTable(table);
  }
}
