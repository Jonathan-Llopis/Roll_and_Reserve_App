import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

import '../../entities/shop_entity.dart';

class GetAllShopsUseCase implements UseCase<Either<Exception, List<ShopEntity>>, NoParams> {
  final ShopsRepository repository;
  GetAllShopsUseCase(this.repository);

  @override
  Future<Either<Exception, List<ShopEntity>>> call(NoParams params) async {
    return repository.getAllShops();
  }
}