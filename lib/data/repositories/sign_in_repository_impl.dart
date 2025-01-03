import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final FirestoreUsersDatasource firebaseUserDataSource;
  final UserDatasource userDatasource;

  LoginRepositoryImpl(this.dataSource, this.sharedPreferences,
      this.firebaseUserDataSource, this.userDatasource);

  @override
  Future<Either<Failure, UserEntity>> signInGoogle() async {
    try {
      UserModel user = await dataSource.signInWithGoogle();
      String tokenGenerado = await userDatasource.getValidToken(user.email);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      await sharedPreferences.setString('token', tokenGenerado);
      UserModel usuerDataBase =
          await userDatasource.getUser(user.email, tokenGenerado);
      return Right(usuerDataBase.toUserEntity());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      String tokenGenerado = await userDatasource.getValidToken(email);
      UserModel user = await dataSource.signIn(email, password);
      await sharedPreferences.setString('token', tokenGenerado);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      final token = sharedPreferences.getString('token');
      UserModel usuerDataBase =
          await userDatasource.getUser(user.email, token!);
      return Right(usuerDataBase.toUserEntity());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      String email, String password, String name) async {
    try {
      UserModel user = await dataSource.signUp(email, password);
      firebaseUserDataSource.registerUser(user.email, name, user.id);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      final token = sharedPreferences.getString('token');
      UserModel usuerDataBase =
          await userDatasource.getUser(user.email, token!);
      return Right(usuerDataBase.toUserEntity());
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> isLoggedIn() async {
    try {
      final id = sharedPreferences.getString('id');
      if (id == null) {
        return Left(AuthFailure());
      } else {
          final token = sharedPreferences.getString('token');
          final email = sharedPreferences.getString('email');
        UserModel usuerDataBase =
            await userDatasource.getUser(email!, token!);
        return Right(usuerDataBase.toUserEntity());
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
      await sharedPreferences.remove('token');
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
