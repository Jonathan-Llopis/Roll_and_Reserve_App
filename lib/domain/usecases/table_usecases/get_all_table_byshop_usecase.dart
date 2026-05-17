import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/repositories/table_respository.dart';

class GetAllTablesByShopUseCase
    implements
        UseCase<Either<Failure, List<TableEntity>>,
            GetTablesByShopUseCaseParams> {
  final TableRepository repository;
  GetAllTablesByShopUseCase(this.repository);

  @override
  Future<Either<Failure, List<TableEntity>>> call(
    GetTablesByShopUseCaseParams params,
  ) async {
    return repository.getAllTablesByShop(params.idShop);
  }
}
