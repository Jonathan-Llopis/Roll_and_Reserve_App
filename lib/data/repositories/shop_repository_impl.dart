import 'package:dartz/dartz.dart';
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
  Future<Either<Exception, List<ShopEntity>>> getAllShops() async {
    try {
      final token = sharedPreferences.getString('token');
      final shopsModels = await remoteDataSource.getAllShops(token!);
      final shopsWithLogo = await Future.wait(
        shopsModels.map((model) async {
          final logo = await remoteDataSource.getShopLogo(model.logoId, token);
          return model.toShopEntity(logo);
        }),
      );
      return Right(shopsWithLogo);
    } catch (e) {
      return Left(Exception('Error al cargar tiendas'));
    }
  }

  @override
  Future<Either<Exception, ShopEntity>> getShop(int idShop) async {
    try {
      final token = sharedPreferences.getString('token');
      final shopModel = await remoteDataSource.getShop(idShop, token!);
      final logo = await remoteDataSource.getShopLogo(shopModel.logoId, token);
      final shopEntity = shopModel.toShopEntity(logo);
      return Right(shopEntity);
    } catch (e) {
      return Left(Exception('Error al obtener la tienda'));
    }
  }

  @override
  Future<Either<Exception, List<ShopEntity>>> getShopByOwner(String ownerId) async {
    try {
      final token = sharedPreferences.getString('token');
      final shopsModels = await remoteDataSource.getShopsByOwner(ownerId, token!);
      final shopsWithLogo = await Future.wait(
        shopsModels.map((model) async {
          final logo = await remoteDataSource.getShopLogo(model.logoId, token);
          return model.toShopEntity(logo);
        }),
      );
      return Right(shopsWithLogo);
    } catch (e) {
      return Left(Exception('Error al obtener las tiendas del propietario'));
    }
  }

  @override
  Future<Either<Exception, bool>> deleteShops(int idShops) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteShops(idShops, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar la tienda'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateShops(ShopEntity shops) async {
    try {
      final token = sharedPreferences.getString('token');
      String logoId =
          await remoteDataSource.updateLogo(shops.toShopModel(null), token!);
      ShopModel shopModel = shops.toShopModel(logoId);
      await remoteDataSource.updateShops(shopModel, token);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al actualizar la tienda: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> createShops(ShopEntity shops) async {
    try {
      final token = sharedPreferences.getString('token');
      ShopModel shopModel = shops.toShopModel(null);
      final shopModelCreated =
          await remoteDataSource.createShops(shopModel, token!);
      ShopModel avatarShop =
          shopModel.addInfo("677e565be78534b20cb542b0  ", shopModelCreated.id);
      String logoId = await remoteDataSource.updateLogo(avatarShop, token);
      ShopModel updateShop = shopModel.addInfo(logoId, shopModelCreated.id);
      await remoteDataSource.updateShops(updateShop, token);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al crear la tienda: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Exception, List<dynamic>>> getMostPlayedGames(
      int idShop, String startTime, String endTime) async {
    try {
      final token = sharedPreferences.getString('token');
      final games = await remoteDataSource.getMostPlayedGames(idShop, startTime, endTime, token!);
      return Right(games);
    } catch (e) {
      return Left(Exception('Error al obtener los juegos más jugados.'));
    }
  }

  @override
  Future<Either<Exception, int>> getTotalReservations(
      int idShop, String startTime, String endTime) async {
    try {
      final token = sharedPreferences.getString('token');
      final totalReservations = await remoteDataSource.getTotalReservations(idShop, startTime, endTime, token!);
      return Right(totalReservations);
    } catch (e) {
      return Left(Exception('Error al obtener el total de reservas.'));
    }
  }

  @override
  Future<Either<Exception, int>> getPlayerCount(
      int idShop, String startTime, String endTime) async {
    try {
      final token = sharedPreferences.getString('token');
      final playerCount = await remoteDataSource.getPlayerCount(idShop, startTime, endTime, token!);
      return Right(playerCount);
    } catch (e) {
      return Left(Exception('Error al obtener el conteo de jugadores.'));
    }
  }

  @override
  Future<Either<Exception, List<dynamic>>> getPeakReservationHours(
      int idShop, String startTime, String endTime) async {
    try {
      final token = sharedPreferences.getString('token');
      final peakHours = await remoteDataSource.getPeakReservationHours(idShop, startTime, endTime, token!);
      return Right(peakHours);
    } catch (e) {
      return Left(Exception('Error al obtener las horas pico de reservas.'));
    }
  }
}
