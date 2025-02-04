import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetUserInfoUseCase
    implements UseCase<Either<Failure, UserEntity>, String> {
  final UserRespository repository;
  GetUserInfoUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String idUser) async {
    return repository.getUserInfo(idUser);
  }
}
