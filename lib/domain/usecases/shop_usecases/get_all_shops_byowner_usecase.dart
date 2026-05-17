import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

import '../../entities/shop_entity.dart';

class GetAllShopsByOwnerUseCase
    implements
        UseCase<Either<Failure, List<ShopEntity>>,
            GetShopsByOwnerUseCaseParams> {
  final ShopsRepository repository;
  GetAllShopsByOwnerUseCase(this.repository);

  @override
  Future<Either<Failure, List<ShopEntity>>> call(
    GetShopsByOwnerUseCaseParams params,
  ) async {
    return repository.getShopByOwner(params.idOwner);
  }
}
