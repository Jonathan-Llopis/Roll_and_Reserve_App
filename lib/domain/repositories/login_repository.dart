import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
  Future<Either<Failure, UserModel>> signUp(String email, String password,  String name);
  Future<Either<Failure, UserModel>> signInGoogle();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, bool>> isEmailUsed(String email);
}
