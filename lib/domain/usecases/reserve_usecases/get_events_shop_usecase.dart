import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';


class GetEventsShopUsecase implements UseCase<Either<Exception, List<ReserveEntity>>, GetEventsParams> {
  final ReserveRepository repository;
  GetEventsShopUsecase(this.repository);

  @override
  Future<Either<Exception, List<ReserveEntity>>> call(GetEventsParams params) async {
    return await repository.getEvents(params.idShop);
  }
}