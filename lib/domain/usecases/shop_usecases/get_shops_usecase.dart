import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

import '../../entities/shop_entity.dart';

class GetShopUseCase implements UseCase<Either<Exception, ShopEntity>, GetShopUseCaseParams> {
  final ShopsRepository repository;
  GetShopUseCase(this.repository);

  @override
  Future<Either<Exception, ShopEntity>> call(GetShopUseCaseParams params) async {
    return repository.getShop(params.idShop);
  }
}