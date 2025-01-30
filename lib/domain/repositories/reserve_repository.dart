import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

abstract class ReserveRepository {
  Future<Either<Exception, List<ReserveEntity>>> getAllReserves();
  Future<Either<Exception, bool>> deleteReserve(int idReserve);
  Future<Either<Exception, bool>> updateReserve(ReserveEntity reserve);
  Future<Either<Exception, int>> createReserve(ReserveEntity reserve);
  Future<Either<Exception, bool>> addUserToReserve(
      int idReserve, String idUser);
  Future<Either<Exception, bool>> deleteUserOfReserve(
      int idReserve, String idUser);
  Future<Either<Exception, List<ReserveEntity>>> getAllReservesByDate(
      DateTime date, int idTable);
  Future<Either<Exception, ReserveEntity>> getReserveWithUsers(int idReserve);
  Future<Either<Exception, List<ReserveEntity>>> getReservesOfUser(
      String idUser);
  Future<Either<Exception, bool>> confirmReserve(int idReserve);
  Future<Either<Exception, List<int>>> createMultipleReservesEvent(
      List<ReserveEntity> reserves);
  Future<Either<Exception, List<ReserveEntity>>> getEvents(int idShop);
}
