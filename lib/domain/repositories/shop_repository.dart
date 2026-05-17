import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

abstract class ShopsRepository {
  Future<Either<Failure, List<ShopEntity>>> getAllShops();
  Future<Either<Failure, bool>> deleteShops(int idShops);
  Future<Either<Failure, bool>> updateShops(ShopEntity shops);
  Future<Either<Failure, bool>> createShops(ShopEntity shops);
  Future<Either<Failure, ShopEntity>> getShop(int idShop);
  Future<Either<Failure, List<ShopEntity>>> getShopByOwner(String idOwner);
  Future<Either<Failure, List<dynamic>>> getMostPlayedGames(
    int idShop,
    String startTime,
    String endTime,
  );
  Future<Either<Failure, int>> getTotalReservations(
    int idShop,
    String startTime,
    String endTime,
  );
  Future<Either<Failure, int>> getPlayerCount(
    int idShop,
    String startTime,
    String endTime,
  );
  Future<Either<Failure, List<dynamic>>> getPeakReservationHours(
    int idShop,
    String startTime,
    String endTime,
  );
}
