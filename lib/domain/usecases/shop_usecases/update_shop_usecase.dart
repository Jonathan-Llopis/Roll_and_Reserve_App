import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class UpdateShopsUseCase implements UseCase<Either<Failure, bool>, ShopEntity> {
  final ShopsRepository repository;
  UpdateShopsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ShopEntity shops) async {
    return repository.updateShops(shops);
  }
}
