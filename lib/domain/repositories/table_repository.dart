import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

abstract class TableRepository {
  Future<Either<Failure, List<TableEntity>>> getAllTables();
  Future<Either<Failure, bool>> deleteTable(int idTable);
  Future<Either<Failure, bool>> updateTable(TableEntity table);
  Future<Either<Failure, bool>> createTable(TableEntity table);
  Future<Either<Failure, List<TableEntity>>> getAllTablesByShop(int idShop);
}
