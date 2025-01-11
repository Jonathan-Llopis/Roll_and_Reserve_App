import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(String email, String password,  String name, String username);
  Future<Either<Failure, UserEntity>> signInGoogle();
  Future<Either<Failure, UserEntity>> isLoggedIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, bool>> isEmailUsed(String email);
  Future<Either<Failure, bool>> isNameUsed(String name);
  Future<Either<Failure, bool>> updateUserInfo(UserEntity user);
  Future<Either<Failure, bool>> updatePassword(String password);
  Future<Either<Failure, bool>> validatePassword(String password);
  Future<Either<Failure, UserEntity>> getUserInfo(String idUser);
  Future<Either<Failure, List<UserEntity>>> getUsersInfo();
}
