import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/reserve_repository.dart';

class GetLastTenPlayersUseCase
  implements UseCase<Either<Exception, List<UserEntity>>, IdGoogleParams> {
  final ReserveRepository repository;
  GetLastTenPlayersUseCase(this.repository);

  @override
  Future<Either<Exception, List<UserEntity>>> call(IdGoogleParams params) async {
    return repository.getLastTenPlayers(params.googleId);
  }
}

class IdGoogleParams {
  final String googleId;
  IdGoogleParams({required this.googleId});
}
