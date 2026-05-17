import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class GetPlayerCountUseCase
    implements UseCase<Either<Failure, int>, StadisticsParams> {
  final ShopsRepository repository;
  GetPlayerCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(StadisticsParams params) async {
    return repository.getPlayerCount(
      params.idShop,
      params.startTime,
      params.endTime,
    );
  }
}
