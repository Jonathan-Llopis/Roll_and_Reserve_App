import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class GetMostPlayedGamesUseCase implements UseCase<Either<Exception, List<dynamic>>, StadisticsParams> {
  final ShopsRepository repository;
  GetMostPlayedGamesUseCase(this.repository);

  @override
  Future<Either<Exception, List<dynamic>>> call(StadisticsParams params) async {
    return repository.getMostPlayedGames(params.idShop, params.startTime, params.endTime);
  }
}
