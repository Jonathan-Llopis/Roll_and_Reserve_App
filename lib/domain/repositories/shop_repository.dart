import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

abstract class ShopsRepository {
  Future<Either<Exception, List<ShopEntity>>> getAllShops();
  Future<Either<Exception, bool>> deleteShops(int idShops);
  Future<Either<Exception, bool>> updateShops(ShopEntity shops);
  Future<Either<Exception, bool>> createShops(ShopEntity shops);
  Future<Either<Exception, ShopEntity>> getShop(int idShop);
  Future<Either<Exception, List<ShopEntity>>> getShopByOwner(String idOwner);
  Future<Either<Exception, List<dynamic>>>
      getMostPlayedGames(int idShop, String startTime, String endTime);
  Future<Either<Exception, int>> getTotalReservations(
      int idShop, String startTime, String endTime);
  Future<Either<Exception, int>> getPlayerCount(
      int idShop, String startTime, String endTime);
  Future<Either<Exception, List<dynamic>>>
      getPeakReservationHours(int idShop, String startTime, String endTime);  
}