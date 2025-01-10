import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

abstract class TableRepository {
  Future<Either<Exception, List<TableEntity>>> getAllTables();
  Future<Either<Exception, bool>> deleteTable(int idTable);
  Future<Either<Exception, bool>> updateTable(TableEntity table);
  Future<Either<Exception, bool>> createTable(TableEntity table);

}