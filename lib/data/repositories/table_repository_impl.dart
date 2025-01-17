import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/table_datasource.dart';
import 'package:roll_and_reserve/data/models/table_model.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TableRepositoryImpl implements TableRepository {
  final TableRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  TableRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override
  Future<Either<Exception, List<TableEntity>>> getAllTables() async {
    try {
      final token = sharedPreferences.getString('token');
      final tableModels = await remoteDataSource.getAllTables(token!);
      return Right(tableModels.map((model) => model.toTableEntity()).toList());
    } catch (e) {
      return Left(Exception('Error al cargar la mesa'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteTable(int idTable) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteTables(idTable, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar la mesa'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateTable(TableEntity table) async {
    try {
      final token = sharedPreferences.getString('token');
      TableModel shopModel = table.toTableModel();
      await remoteDataSource.updateTables(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al actualizar la mesa: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> createTable(TableEntity table) async {
    try {
      final token = sharedPreferences.getString('token');
      TableModel shopModel = table.toTableModel();
      await remoteDataSource.createTables(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al crear la mesa: ${e.toString()}'));
    }
  }
}
