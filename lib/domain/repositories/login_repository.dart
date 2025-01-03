import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signUp(String email, String password,  String name);
  Future<Either<Failure, UserEntity>> signInGoogle();
  Future<Either<Failure, UserEntity>> isLoggedIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, bool>> isEmailUsed(String email);
  Future<Either<Failure, bool>> isNameUsed(String name);
}
