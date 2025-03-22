import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/repositories/shop_repository.dart';

class GetTotalReservationsUseCase implements UseCase<Either<Exception, int>, StadisticsParams> {
  final ShopsRepository repository;
  GetTotalReservationsUseCase(this.repository);

  @override
  Future<Either<Exception, int>> call(StadisticsParams params) async {
    return repository.getTotalReservations(params.idShop, params.startTime, params.endTime);
  }
}
