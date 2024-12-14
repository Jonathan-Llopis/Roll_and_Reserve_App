import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';

abstract class SignInRepository {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
   Future<Either<Failure, UserModel>> signInGoogle();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> logout();
}
