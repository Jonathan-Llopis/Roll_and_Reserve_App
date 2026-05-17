import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class GetMostPlayedGamesUseCase
    implements UseCase<Either<Failure, List<dynamic>>, StadisticsParams> {
  final ShopsRepository repository;
  GetMostPlayedGamesUseCase(this.repository);

  @override
  Future<Either<Failure, List<dynamic>>> call(StadisticsParams params) async {
    return repository.getMostPlayedGames(
      params.idShop,
      params.startTime,
      params.endTime,
    );
  }
}
