import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/data/datasources/reserve_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/models/reserve_model.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReserveRepositoryImpl implements ReserveRepository {
  final ReserveRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final UserDatasource userDatasource;

  ReserveRepositoryImpl(
      this.remoteDataSource, this.sharedPreferences, this.userDatasource);

  @override
  /// Gets all reserves from the backend.
  ///
  /// This function fetches all reserves from the backend, using the access token
  /// stored in the SharedPreferences. It then maps these reserves to
  /// [ReserveEntity] and returns them.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveEntity] if the request
  /// is successful. If the status code is 200, returns the list of reserves.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the retrieval process.
  Future<Either<Exception, List<ReserveEntity>>> getAllReserves() async {
    try {
      final token = sharedPreferences.getString('token');
      final reserveModels = await remoteDataSource.getAllReserves(token!);
      List<ReserveEntity> reserveEntities =
          reserveModels.toList().map((reserveModel) {
        return reserveModel.toReserveEntity();
      }).toList();
      return Right(reserveEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reservas'));
    }
  }

  @override
  /// Deletes a reserve from the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve to delete.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the reserve was deleted.
  /// Throws an [Exception] if there is an error during the deletion process.
  Future<Either<Exception, bool>> deleteReserve(int idReserve) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteReserves(idReserve, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar el reserva'));
    }
  }

  @override
  /// Updates a reserve on the backend.
  ///
  /// The [reserve] parameter is the [ReserveEntity] to update.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the reserve was updated.
  /// Throws an [Exception] if there is an error during the update process.
  Future<Either<Exception, bool>> updateReserve(ReserveEntity reserve) async {
    try {
      final token = sharedPreferences.getString('token');
      ReserveModel shopModel = reserve.toReserveModel();
      await remoteDataSource.updateReserves(shopModel, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al actualizar la reserva: ${e.toString()}'));
    }
  }

  @override
  /// Creates a reserve on the backend.
  ///
  /// The [reserve] parameter is the [ReserveEntity] to create.
  ///
  /// Returns a [Future] that resolves to the id of the created reserve if the request is successful.
  /// If the status code is 201, returns the id of the created reserve.
  /// Throws an [Exception] if there is an error during the creation process.
  Future<Either<Exception, int>> createReserve(ReserveEntity reserve) async {
    try {
      final token = sharedPreferences.getString('token');
      ReserveModel shopModel = reserve.toReserveModel();
      int idReserve = await remoteDataSource.createReserves(shopModel, token!, reserve.shopId!);
      return Right(idReserve);
    } catch (e) {
      return Left(Exception('Error al crear la reserva: ${e.toString()}'));
    }
  }

  @override
  /// Adds a user to a reserve on the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve to add the user to.
  /// The [idUser] parameter is the id of the user to add to the reserve.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 201, returns true indicating the user was added.
  /// Throws an [Exception] if there is an error during the addition process.
  Future<Either<Exception, bool>> addUserToReserve(
      int idReserve, String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.addUserToReserve(idReserve, idUser, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al añadir jugador a la reserva: ${e.toString()}'));
    }
  }

  @override
  /// Deletes a user from a reserve on the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve from which the user is being deleted.
  /// The [idUser] parameter is the id of the user being deleted from the reserve.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the user was deleted successfully.
  /// Throws an [Exception] if there is an error during the deletion process.

  Future<Either<Exception, bool>> deleteUserOfReserve(
      int idReserve, String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteUserToReserve(idReserve, idUser, token!);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar jugador de la reserva: ${e.toString()}'));
    }
  }
  @override
  /// Gets all reserves for a given date and table.
  ///
  /// The [date] parameter is the date for which to get the reserves.
  /// The [tableId] parameter is the id of the table for which to get the reserves.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveEntity] if the request is successful.
  /// If the status code is 200, returns the list of reserves.
  /// Throws an [Exception] if there is an error during the retrieval process.
  Future<Either<Exception, List<ReserveEntity>>> getAllReservesByDate(DateTime date, int tableId) async {
    try {
      final token = sharedPreferences.getString('token');
      final formattedDate = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final reserveModels = await remoteDataSource.getAllReservesByDate(formattedDate, token!, tableId);
      List<ReserveEntity> reserveEntities =
          reserveModels.asMap().entries.map((entry) {
        return entry.value.toReserveEntity();
      }).toList();
      return Right(reserveEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reservas por fecha: ${e.toString()}'));
    }
  }
    @override
  /// Gets a reserve with its users from the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve to get.
  ///
  /// Returns a [Future] that resolves to a [ReserveEntity] if the request is successful.
  /// If the status code is 200, returns the reserve with its users.
  /// Throws an [Exception] if there is an error during the retrieval process.
      Future<Either<Exception, ReserveEntity>> getReserveWithUsers(int idReserve) async {
    try {
      final token = sharedPreferences.getString('token');
      final reserveModels = await remoteDataSource.getReserveById(idReserve, token!);
      List<Future<dynamic>> userAvatars = reserveModels.users!.map((user) async {
        return await userDatasource.getUserAvatar(user.avatarId, token);
      }).toList();
      List<dynamic> avatars = await Future.wait(userAvatars);
      ReserveEntity reserveEntity = reserveModels.toReserveEntityWithUsers(avatars);
      return Right(reserveEntity);
    } catch (e) {
      return Left(Exception('Error al cargar reserve'));
    }
  }

  @override
  /// Fetches all reserves associated with a specific user from the backend.
  ///
  /// The [userId] parameter is the ID of the user whose reserves are to be fetched.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveEntity] if the request is successful.
  /// If the request is successful, returns the list of reserves.
  /// Throws an [Exception] if there is an error during the fetch process.

  Future<Either<Exception, List<ReserveEntity>>> getReservesOfUser(String userId) async {
    try {
      final token = sharedPreferences.getString('token');
      final reserveModels = await remoteDataSource.getReservesOfUser(userId, token!);
      List<ReserveEntity> reserveEntities =
          reserveModels.asMap().entries.map((entry) {
        return entry.value.toReserveEntity();
      }).toList();
      return Right(reserveEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reservas del usuario: ${e.toString()}'));
    }
  }
  @override
  /// Confirms a reserve on the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve to confirm.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the reserve was confirmed.
  /// Throws an [Exception] if there is an error during the confirmation process.
  Future<Either<Exception, bool>> confirmReserve(int idReserve) async {
    try {
      final token = sharedPreferences.getString('token');
      final idUser = sharedPreferences.getString('id');
      if (token == null || idUser == null) {
        throw Exception('Token or user ID is missing');
      }
      await remoteDataSource.confirmReserve(idReserve, idUser, token);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al confirmar la reserva: ${e.toString()}'));
    }
  }
  @override
  /// Creates multiple reserves on the backend for a given event.
  ///
  /// The [reserves] parameter is a list of [ReserveEntity] to create.
  ///
  /// Returns a [Future] that resolves to a list of integers if the request is successful.
  /// If the status code is 201, returns the list of IDs of the created reserves.
  /// Throws an [Exception] if there is an error during the creation process.
  Future<Either<Exception, List<int>>> createMultipleReservesEvent(List<ReserveEntity> reserves) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) {
        throw Exception('Token is missing');
      }
      List<int> reserveIds = [];
      for (var reserve in reserves) {
        ReserveModel reserveModel = reserve.toReserveModel();
        int idReserve = await remoteDataSource.createReservesEvent(reserveModel, token, reserve.shopId!);
        reserveIds.add(idReserve);
      }
      return Right(reserveIds);
    } catch (e) {
      return Left(Exception('Error al crear múltiples reservas de evento: ${e.toString()}'));
    }
  }
  @override
  /// Fetches all events for a given shop from the backend.
  ///
  /// The [idShop] parameter is the ID of the shop for which events are to be fetched.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveEntity] if the request is successful.
  /// If the status code is 200, returns the list of events.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the retrieval process.

  Future<Either<Exception, List<ReserveEntity>>> getEvents(int idShop) async {
      try {
      final token = sharedPreferences.getString('token');
      final reserveModels = await remoteDataSource.getEvents(idShop, token!);
      List<ReserveEntity> reserveEntities =
          reserveModels.toList().map((reserveModel) {
        return reserveModel.toReserveEntity();
      }).toList();
      return Right(reserveEntities);
    } catch (e) {
      return Left(Exception('Error al cargar reservas'));
    }
  }
  @override
  /// Fetches the last ten players that reserved a table for a specific user from the backend.
  ///
  /// The [idUser] parameter is the ID of the user whose last ten players are to be fetched.
  ///
  /// Returns a [Future] that resolves to a [List] of [UserEntity] if the request is successful.
  /// The user entities include avatar information.
  /// Throws an [Exception] if there is an error during the fetch process.

  Future<Either<Exception, List<UserEntity>>> getLastTenPlayers(String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      final players = await remoteDataSource.getLastTenPlayers(idUser, token!);
       List<Future<dynamic>> userAvatars = players.map((user) async {
        return await userDatasource.getUserAvatar(user.avatarId, token);
      }).toList();
      List<dynamic> avatars = await Future.wait(userAvatars);
      List<UserEntity> userEntities = players.asMap().entries.map((entry) {
        return players[entry.key].toUserEntity(avatars[entry.key], null);
      }).toList();
      return Right(userEntities);
    } catch (e) {
      return Left(Exception('Error al obtener los últimos diez jugadores: ${e.toString()}'));
    }
  }
}
