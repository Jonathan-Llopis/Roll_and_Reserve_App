import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
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

  /// Retrieves all tables from the backend.
  ///
  /// Fetches the list of tables using the access token stored in shared preferences.
  /// Converts the fetched [TableModel] objects into [TableEntity] objects.
  ///
  /// Returns a [Future] that completes with a [Right] containing a list of [TableEntity]
  /// if the operation is successful, or a [Left] containing an [Exception] if an error occurs.

  Future<Either<Failure, List<TableEntity>>> getAllTables() async {
    try {
      final token = sharedPreferences.getString('token');
      final tableModels = await remoteDataSource.getAllTables(token!);
      return Right(tableModels.map((model) => model.toTableEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Error al cargar la mesa'));
    }
  }

  @override

  /// Deletes the table with the specified [idTable] from the backend.
  ///
  /// Fetches the access token from shared preferences and then calls the
  /// [TableRemoteDataSource.deleteTables] method to perform the deletion.
  ///
  /// Returns a [Future] that completes with a [Right] containing a boolean
  /// indicating whether the request was successful, or a [Left] containing an
  /// [Exception] if an error occurs.
  Future<Either<Failure, bool>> deleteTable(int idTable) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteTables(idTable, token!);
      return const Right(true);
    } catch (e) {
      return const Left(ServerFailure('Error al eliminar la mesa'));
    }
  }

  @override

  /// Updates a table on the backend.
  ///
  /// Converts the given [TableEntity] to a [TableModel] and uses the stored token
  /// to authorize the request to the remote data source.
  ///
  /// Returns a [Future] that resolves to a [Right] containing `true` if the
  /// request is successful, or a [Left] containing an [Exception] if an
  /// error occurs during the operation.
  Future<Either<Failure, bool>> updateTable(TableEntity table) async {
    try {
      final token = sharedPreferences.getString('token');
      TableModel shopModel = table.toTableModel();
      await remoteDataSource.updateTables(shopModel, token!);
      return const Right(true);
    } catch (e) {
      return Left(
        ServerFailure('Error al actualizar la mesa: ${e.toString()}'),
      );
    }
  }

  @override

  /// Creates a table on the backend.
  ///
  /// Converts the given [TableEntity] to a [TableModel] and uses the stored token
  /// to authorize the request to the remote data source.
  ///
  /// Returns a [Future] that resolves to a [Right] containing `true` if the
  /// request is successful, or a [Left] containing an [Exception] if an
  /// error occurs during the operation.
  Future<Either<Failure, bool>> createTable(TableEntity table) async {
    try {
      final token = sharedPreferences.getString('token');
      TableModel shopModel = table.toTableModel();
      await remoteDataSource.createTables(shopModel, token!);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Error al crear la mesa: ${e.toString()}'));
    }
  }

  @override

  /// Retrieves all tables for a specific shop from the backend.
  ///
  /// Fetches the list of tables associated with the given [shopId] using the
  /// access token stored in shared preferences. Converts the fetched
  /// [TableModel] objects into [TableEntity] objects.
  ///
  /// Returns a [Future] that completes with a [Right] containing a list of
  /// [TableEntity] if the operation is successful, or a [Left] containing an
  /// [Exception] if an error occurs.

  Future<Either<Failure, List<TableEntity>>> getAllTablesByShop(
    int shopId,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      final tableModels =
          await remoteDataSource.getAllTablesByShop(shopId, token!);
      return Right(tableModels.map((model) => model.toTableEntity()).toList());
    } catch (e) {
      return const Left(ServerFailure('Error al cargar las mesas por tienda'));
    }
  }
}
