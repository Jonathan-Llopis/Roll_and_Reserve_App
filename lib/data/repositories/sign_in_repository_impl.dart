import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final FirestoreUsersDatasource firebaseUserDataSource;

  LoginRepositoryImpl(
      this.dataSource, this.sharedPreferences, this.firebaseUserDataSource);

  @override
  Future<Either<Failure, UserModel>> signInGoogle() async {
    try {
      UserModel user = await dataSource.signInWithGoogle();
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp(
      String email, String password, String name) async {
    try {
      UserModel user = await dataSource.signUp(email, password);
      firebaseUserDataSource.registerUser(user.email, name, user.id);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      final id = sharedPreferences.getString('id');
      if (id == null) {
        return Right("NO_USER");
      } else {
        return Right(id);
      }
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      await sharedPreferences.remove('id');
      await sharedPreferences.remove('email');
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailUsed(String email) async {
    try {
      bool isUsed = await firebaseUserDataSource.isEmailUsed(email);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isNameUsed(String name) async {
    try {
      bool isUsed = await firebaseUserDataSource.isNameUsed(name);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
