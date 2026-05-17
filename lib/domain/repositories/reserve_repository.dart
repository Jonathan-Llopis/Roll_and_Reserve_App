import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

abstract class ReserveRepository {
  Future<Either<Failure, List<ReserveEntity>>> getAllReserves();
  Future<Either<Failure, bool>> deleteReserve(int idReserve);
  Future<Either<Failure, bool>> updateReserve(ReserveEntity reserve);
  Future<Either<Failure, int>> createReserve(ReserveEntity reserve);
  Future<Either<Failure, bool>> addUserToReserve(
    int idReserve,
    String idUser,
  );
  Future<Either<Failure, bool>> deleteUserOfReserve(
    int idReserve,
    String idUser,
  );
  Future<Either<Failure, List<ReserveEntity>>> getAllReservesByDate(
    DateTime date,
    int idTable,
  );
  Future<Either<Failure, ReserveEntity>> getReserveWithUsers(int idReserve);
  Future<Either<Failure, List<ReserveEntity>>> getReservesOfUser(
    String idUser,
  );
  Future<Either<Failure, bool>> confirmReserve(int idReserve);
  Future<Either<Failure, List<int>>> createMultipleReservesEvent(
    List<ReserveEntity> reserves,
  );
  Future<Either<Failure, List<ReserveEntity>>> getEvents(int idShop);
  Future<Either<Failure, List<UserEntity>>> getLastTenPlayers(String idGoogle);
}
