import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class UpdateUserInfoUseCase
    implements UseCase<Either<Failure, bool>, UserEntity> {
  final UserRespository repository;
  UpdateUserInfoUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UserEntity user) async {
    return repository.updateUserInfo(user);
  }
}
