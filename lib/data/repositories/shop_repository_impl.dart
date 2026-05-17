import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/datasources/shop_datasoruce.dart';
import 'package:roll_and_reserve/data/models/shop_model.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ShopRepositoryImpl implements ShopsRepository {
  final ShopRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  ShopRepositoryImpl(this.remoteDataSource, this.sharedPreferences);

  @override

  /// Fetches all shops from the backend and returns them as a list of [ShopEntity].
  ///
  /// Retrieves a list of all shops and their associated logos from the backend.
  /// The method uses a stored token for authorization and maps the resulting
  /// [ShopModel]s to [ShopEntity]s including the shop logos.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a list of [ShopEntity]
  /// if the operation is successful, or a [Left] containing an [Failure] if an
  /// error occurs.

  Future<Either<Failure, List<ShopEntity>>> getAllShops() async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final shopsModels = await remoteDataSource.getAllShops(token);
      final shopsWithLogo = await Future.wait(
        shopsModels.map((model) async {
          final logo = await remoteDataSource.getShopLogo(model.logoId, token);
          return model.toShopEntity(logo);
        }),
      );
      return Right(shopsWithLogo);
    } catch (e) {
      return Left(ServerFailure('Error al cargar tiendas: ${e.toString()}'));
    }
  }

  @override

  /// Fetches a shop from the backend with the given [idShop].
  ///
  /// Retrieves the shop with the given [idShop] and its associated logo from the
  /// backend. The method uses a stored token for authorization and maps the
  /// resulting [ShopModel] to a [ShopEntity] including the shop logo.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a [ShopEntity]
  /// if the operation is successful, or a [Left] containing an [Failure] if an
  /// error occurs.
  Future<Either<Failure, ShopEntity>> getShop(int idShop) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final shopModel = await remoteDataSource.getShop(idShop, token);
      final logo = await remoteDataSource.getShopLogo(shopModel.logoId, token);
      final shopEntity = shopModel.toShopEntity(logo);
      return Right(shopEntity);
    } catch (e) {
      return Left(ServerFailure('Error al obtener la tienda: ${e.toString()}'));
    }
  }

  @override

  /// Fetches a list of shops owned by the user with the given [ownerId]
  /// from the backend.
  ///
  /// Retrieves the list of shops owned by the user with the given [ownerId]
  /// and their associated logos from the backend. The method uses a stored
  /// token for authorization and maps the resulting [ShopModel] to a
  /// [ShopEntity] including the shop logo.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a [List] of
  /// [ShopEntity] if the operation is successful, or a [Left] containing an
  /// [Failure] if an error occurs.
  Future<Either<Failure, List<ShopEntity>>> getShopByOwner(
    String ownerId,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final shopsModels =
          await remoteDataSource.getShopsByOwner(ownerId, token);
      final shopsWithLogo = await Future.wait(
        shopsModels.map((model) async {
          final logo = await remoteDataSource.getShopLogo(model.logoId, token);
          return model.toShopEntity(logo);
        }),
      );
      return Right(shopsWithLogo);
    } catch (e) {
      return Left(
        ServerFailure('Error al obtener las tiendas: ${e.toString()}'),
      );
    }
  }

  @override

  /// Deletes the shop with the specified [idShops] from the backend.
  ///
  /// Uses a stored token for authorization to delete the shop.
  ///
  /// Returns a [Future] that resolves to a [Right] containing `true` if the
  /// deletion is successful, or a [Left] containing an [Failure] if an
  /// error occurs during the operation.

  Future<Either<Failure, bool>> deleteShops(int idShops) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      await remoteDataSource.deleteShops(idShops, token);
      return const Right(true);
    } catch (e) {
      return Left(
        ServerFailure('Error al eliminar la tienda: ${e.toString()}'),
      );
    }
  }

  @override

  /// Updates a shop on the backend.
  ///
  /// Uses a stored token for authorization to update the shop.
  ///
  /// Returns a [Future] that resolves to a [Right] containing `true` if the
  /// update is successful, or a [Left] containing an [Failure] if an
  /// error occurs during the operation.
  Future<Either<Failure, bool>> updateShops(ShopEntity shops) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      String logoId =
          await remoteDataSource.updateLogo(shops.toShopModel(null), token);
      ShopModel shopModel = shops.toShopModel(logoId);
      await remoteDataSource.updateShops(shopModel, token);
      return const Right(true);
    } catch (e) {
      return Left(
        ServerFailure('Error al actualizar la tienda: ${e.toString()}'),
      );
    }
  }

  @override

  /// Creates a new shop on the backend.
  ///
  /// Converts the given [ShopEntity] to a [ShopModel] and uses a stored token
  /// for authorization to create the shop. Additionally, it updates the shop
  /// with a logo if provided.
  ///
  /// Returns a [Future] that resolves to a [Right] containing `true` if the
  /// creation is successful, or a [Left] containing an [Failure] if an
  /// error occurs during the operation.

  Future<Either<Failure, bool>> createShops(ShopEntity shops) async {
    try {
      String logoId;
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      ShopModel shopModel = shops.toShopModel(null);
      final shopModelCreated =
          await remoteDataSource.createShops(shopModel, token);
      ShopModel avatarShop =
          shopModel.addInfo('67c4bf45ae01906bd75ace8f  ', shopModelCreated.id);
      if (avatarShop.logo == null) {
        logoId = '67c4bf45ae01906bd75ace8f';
      } else {
        logoId = await remoteDataSource.updateLogo(avatarShop, token);
      }
      ShopModel updateShop = shopModel.addInfo(logoId, shopModelCreated.id);
      await remoteDataSource.updateShops(updateShop, token);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Error al crear la tienda: ${e.toString()}'));
    }
  }

  @override

  /// Fetches the most played games for a given shop and time period from the
  /// backend.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch
  /// the most played games.
  ///
  /// The [startTime] and [endTime] parameters are the start and end times of
  /// the time period for which to fetch the most played games.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a list of
  /// objects containing the game identifiers, names and play counts if the
  /// request is successful, or a [Left] containing an [Failure] if an error
  /// occurs during the operation.
  Future<Either<Failure, List<dynamic>>> getMostPlayedGames(
    int idShop,
    String startTime,
    String endTime,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final games = await remoteDataSource.getMostPlayedGames(
        idShop,
        startTime,
        endTime,
        token,
      );
      return Right(games);
    } catch (e) {
      return Left(
        ServerFailure(
          'Error al obtener los juegos más jugados: ${e.toString()}',
        ),
      );
    }
  }

  @override

  /// Fetches the total number of reservations for a given shop and time period
  /// from the backend.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch the
  /// total number of reservations.
  ///
  /// The [startTime] and [endTime] parameters are the start and end times of the
  /// time period for which to fetch the total number of reservations.
  ///
  /// Returns a [Future] that resolves to a [Right] containing the total number
  /// of reservations if the request is successful, or a [Left] containing an
  /// [Failure] if an error occurs during the operation.
  Future<Either<Failure, int>> getTotalReservations(
    int idShop,
    String startTime,
    String endTime,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final totalReservations = await remoteDataSource.getTotalReservations(
        idShop,
        startTime,
        endTime,
        token,
      );
      return Right(totalReservations);
    } catch (e) {
      return Left(
        ServerFailure(
          'Error al obtener el total de reservas: ${e.toString()}',
        ),
      );
    }
  }

  @override

  /// Fetches the player count for a given shop and time period from the
  /// backend.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch
  /// the player count.
  ///
  /// The [startTime] and [endTime] parameters are the start and end times of the
  /// time period for which to fetch the player count.
  ///
  /// Returns a [Future] that resolves to a [Right] containing the player count
  /// if the request is successful, or a [Left] containing an [Failure] if an
  /// error occurs during the operation.
  Future<Either<Failure, int>> getPlayerCount(
    int idShop,
    String startTime,
    String endTime,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final playerCount = await remoteDataSource.getPlayerCount(
        idShop,
        startTime,
        endTime,
        token,
      );
      return Right(playerCount);
    } catch (e) {
      return Left(
        ServerFailure(
          'Error al obtener el conteo de jugadores: ${e.toString()}',
        ),
      );
    }
  }

  @override

  /// Fetches the peak reservation hours for a given shop and time period
  /// from the backend.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch
  /// the peak reservation hours.
  ///
  /// The [startTime] and [endTime] parameters are the start and end times of
  /// the time period for which to fetch the peak reservation hours.
  ///
  /// Returns a [Future] that resolves to a [Right] containing a list of
  /// objects with hour and reservation count if the request is successful,
  /// or a [Left] containing an [Failure] if an error occurs during the
  /// operation.

  Future<Either<Failure, List<dynamic>>> getPeakReservationHours(
    int idShop,
    String startTime,
    String endTime,
  ) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) return const Left(AuthFailure('No token found'));
      final peakHours = await remoteDataSource.getPeakReservationHours(
        idShop,
        startTime,
        endTime,
        token,
      );
      return Right(peakHours);
    } catch (e) {
      return Left(
        ServerFailure(
          'Error al obtener las horas pico de reservas: ${e.toString()}',
        ),
      );
    }
  }
}
