import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';
class GetAllTablesUseCase implements UseCase<Either<Exception, List<TableEntity>>, NoParams> {
  final TableRepository repository;
  GetAllTablesUseCase(this.repository);

  @override
  Future<Either<Exception, List<TableEntity>>> call(NoParams params) async {
    return repository.getAllTables();
  }
}