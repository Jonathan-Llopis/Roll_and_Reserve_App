import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

abstract class ShopsRepository {
  Future<Either<Exception, List<ShopEntity>>> getAllShops();
  Future<Either<Exception, bool>> deleteShops(int idShops);
  Future<Either<Exception, bool>> updateShops(ShopEntity shops);
  Future<Either<Exception, bool>> createShops(ShopEntity shops);
}