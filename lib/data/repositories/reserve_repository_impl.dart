import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/reserve_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/models/reserve_model.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReserveRepositoryImpl implements ReserveRepository {
  final ReserveRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final UserDatasource userDatasource;

  ReserveRepositoryImpl(
      this.remoteDataSource, this.sharedPreferences, this.userDatasource);

  @override
  Future<Either<Exception, List<ReserveEntity>>> getAllReserves() async {
    try {
      final token = sharedPreferences.getString('token');
      final reserveModels = await remoteDataSource.getAllReserves(token!);
      List<Future<List<dynamic>>> avatarFiles =
          reserveModels.map((reserve) async {
        List<Future<dynamic>> userAvatars =
            reserve.usersReserve.map((user) async {
          return await userDatasource.getUserAvatar(user.avatarId, token);
        }).toList();
        return Future.wait(userAvatars);
      }).toList();
      List<List<dynamic>> avatars = await Future.wait(avatarFiles);
      List<ReserveEntity> reserveEntities =
          reserveModels.asMap().entries.map((entry) {
        return entry.value.toReserveEntity(avatars[entry.key]);
      }).toList();
      return Right(reserveEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reserve'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteReserve(int idReserve) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteReserves(idReserve, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar el Reserve'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateReserve(ReserveEntity reserve) async {
    try {
      final token = sharedPreferences.getString('token');
      ReserveModel shopModel = reserve.toReserveModel();
      await remoteDataSource.updateReserves(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al actualizar el mesa: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, int>> createReserve(ReserveEntity reserve) async {
    try {
      final token = sharedPreferences.getString('token');
      ReserveModel shopModel = reserve.toReserveModel();
      int idReserve = await remoteDataSource.createReserves(shopModel, token!);
      return Right(idReserve);
    } catch (e) {
      return Left(Exception('Error al crear la reserva: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> addUserToReserve(
      int idReserve, String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.addUserToReserve(idReserve, idUser, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al añadir jugador: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteUserOfReserve(
      int idReserve, String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteUserToReserve(idReserve, idUser, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar jugador: ${e.toString()}'));
    }
  }

}
