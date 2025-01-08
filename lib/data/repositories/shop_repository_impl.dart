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
     return Left(Exception('Error al cargar shops'));
   }
 }
  @override
  Future<Either<Exception, bool>> deleteShops(int idShops) async {
    try {
      final token = sharedPreferences.getString('token');
      await remoteDataSource.deleteShops(idShops, token!);
      return const Right(true);
    } catch (e) {
      return Left(Exception('Error al eliminar el Shops'));
    }
  }

  @override
  Future<Either<Exception, bool>> updateShops(
      ShopEntity shops) async {
    try {
      final token = sharedPreferences.getString('token');
      String logoId =
          await remoteDataSource.updateAvatar(shops.toShopModel(null), token!);
      ShopModel shopModel = shops.toShopModel(logoId);
      await remoteDataSource.updateShops(shopModel, token);
      return Right(true);
    } catch (e) {
      return Left(
          Exception('Error al actualizar el inventario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, bool>> createShops(ShopEntity shops) async {
    try {
      final token = sharedPreferences.getString('token');
      ShopModel shopModel = shops.toShopModel(null);
      final shopModelCreated =await remoteDataSource.createShops(shopModel, token!);
      ShopModel avatarShop = shopModel.addInfo("677e565be78534b20cb542b0  ", shopModelCreated.id);
      String logoId =
          await remoteDataSource.updateAvatar(avatarShop, token);
       ShopModel updateShop = shopModel.addInfo(logoId, shopModelCreated.id);
      await remoteDataSource.updateShops(updateShop, token);
      return Right(true);
    } catch (e) {
      return Left(Exception('Error al crear el inventario: ${e.toString()}'));
    }
  }
}
