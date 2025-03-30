import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:roll_and_reserve/core/failure.dart';
import 'package:roll_and_reserve/data/datasources/firebase_auth_datasource.dart';
import 'package:roll_and_reserve/data/datasources/firestore_users_datasource.dart';
import 'package:roll_and_reserve/data/datasources/user_datasource.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRespositoryImpl implements UserRespository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final FirestoreUsersDatasource firebaseUserDataSource;
  final UserDatasource userDatasource;

  UserRespositoryImpl(this.dataSource, this.sharedPreferences,
      this.firebaseUserDataSource, this.userDatasource);
  @override
  Future<Either<Failure, UserEntity>> signInGoogle() async {
    try {
      UserModel user = await dataSource.signInWithGoogle();
      bool isUserRegistered =
          await firebaseUserDataSource.isEmailUsed(user.email);

      if (!isUserRegistered) {
        firebaseUserDataSource.registerUser(
          user.email,
          user.name,
          user.id,
        );

        UserModel usuarioRegistro = UserModel(
          email: user.email,
          id: user.id,
          name: user.name,
          username: user.username,
          role: 2,
          avatarId: user.avatarId,
          avatar: File(""),
          averageRaiting: 0,
          notifications: [],
        );
        await userDatasource.createUser(usuarioRegistro, "1");
      }

      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);

      String tokenGenerado =
          await userDatasource.getValidToken(user.email, "1");
      await sharedPreferences.setString('token', tokenGenerado);

      UserModel usuerDataBase =
          await userDatasource.getValidUser(user.id, tokenGenerado);
      dynamic avatarFile = await userDatasource.getUserAvatar(
          usuerDataBase.avatarId, tokenGenerado);

      bool isFirstTime = await firebaseUserDataSource.isFirstTime(user.id);
      await sharedPreferences.setBool('isFirstTime', isFirstTime);

      return Right(usuerDataBase.toUserEntity(avatarFile, null));
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      String tokenGenerado =
          await userDatasource.getValidToken(email, password);
      UserModel user = await dataSource.signIn(email, password);
      await sharedPreferences.setString('token', tokenGenerado);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      final token = sharedPreferences.getString('token');
      UserModel usuerDataBase =
          await userDatasource.getValidUser(user.id, token!);
      dynamic avatarFile =
          await userDatasource.getUserAvatar(usuerDataBase.avatarId, token);

      bool isFirstTime = await firebaseUserDataSource.isFirstTime(user.id);
      await sharedPreferences.setBool('isFirstTime', isFirstTime);
      return Right(usuerDataBase.toUserEntity(avatarFile, null));
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      String email, String password, String name, String username) async {
    try {
      UserModel user = await dataSource.signUp(email, password);
      firebaseUserDataSource.registerUser(
        user.email,
        name,
        user.id,
      );
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);

      UserModel usuarioRegistro = UserModel(
        email: email,
        id: user.id,
        name: name,
        username: username,
        role: 2,
        avatarId: user.avatarId,
        avatar: File(""),
        averageRaiting: 0,
        notifications: [],
      );
      await userDatasource.createUser(usuarioRegistro, password);
      String tokenGenerado =
          await userDatasource.getValidToken(email, password);
      await sharedPreferences.setString('token', tokenGenerado);

      bool isFirstTime = await firebaseUserDataSource.isFirstTime(user.id);
      await sharedPreferences.setBool('isFirstTime', isFirstTime);

      return Right(usuarioRegistro.toUserEntity(File(''), null));
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
        final id = sharedPreferences.getString('id');
        UserModel usuerDataBase =
            await userDatasource.getValidUser(id!, token!);
        usuerDataBase.notifications =
            await firebaseUserDataSource.getUserNotifications(id);
        dynamic avatarFile =
            await userDatasource.getUserAvatar(usuerDataBase.avatarId, token);
        return Right(usuerDataBase.toUserEntity(avatarFile, null));
      }
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo(String idUser) async {
    try {
      final token = sharedPreferences.getString('token');
      UserModel usuerDataBase =
          await userDatasource.getValidUser(idUser, token!);
      dynamic avatarFile =
          await userDatasource.getUserAvatar(usuerDataBase.avatarId, token);
      return Right(usuerDataBase.toUserEntity(avatarFile, null));
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final token = sharedPreferences.getString('token');
      final id = sharedPreferences.getString('id');
      await userDatasource.updateTokenNotification(id!, " ", token!);
      await dataSource.logout();
      await sharedPreferences.remove('id');
      await sharedPreferences.remove('email');
      await sharedPreferences.remove('token');
      await sharedPreferences.remove('isFirstTime');
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

  @override
  Future<Either<Failure, bool>> updateUserInfo(UserEntity user) async {
    try {
      late UserModel userModel;
      final token = sharedPreferences.getString('token');
      await firebaseUserDataSource.updateUserInfo(
          user.name, user.id, user.role, user.notifications);
      if (user.avatar != null) {
        String avatarId =
            await userDatasource.updateAvatar(user.toUserModel(null), token!);
        userModel = user.toUserModel(avatarId);
      } else {
        userModel = user.toUserModel(null);
      }
      await userDatasource.updateUserInfo(userModel, token!);
      return Right(true);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword(
      String password, String oldPassword) async {
    try {
      final token = sharedPreferences.getString('token');
      await dataSource.updatePassword(password);
      await userDatasource.updatePassword(
          sharedPreferences.getString('id')!, oldPassword, password, token!);
      return Right(true);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> validatePassword(String password) async {
    try {
      final email = sharedPreferences.getString('email');
      bool isValid = await dataSource.validatePassword(password, email!);
      return Right(isValid);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsersInfo() async {
    try {
      final token = sharedPreferences.getString('token');
      List<UserModel> usersDataBase = await userDatasource.getUsers(token!);
      List<Future<dynamic>> avatarFiles = usersDataBase.map((user) async {
        return await userDatasource.getUserAvatar(user.avatarId, token);
      }).toList();
      List<dynamic> avatars = await Future.wait(avatarFiles);
      List<UserEntity> usersEntity = usersDataBase.asMap().entries.map((entry) {
        return entry.value.toUserEntity(avatars[entry.key], null);
      }).toList();
      return Right(usersEntity);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateTokenNotification(
      String id, String tokenNotification) async {
    try {
      final token = sharedPreferences.getString('token');
      final id = sharedPreferences.getString('id');
      if (id == null) {
        return Left(AuthFailure());
      }
      await userDatasource.updateTokenNotification(
          id, tokenNotification, token!);
      return Right(true);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
  @override
  Future<Either<Failure, bool>> saveUserField(String id, String field, dynamic value) async {
    try {
      final token = sharedPreferences.getString('token');
      if (token == null) {
        return Left(AuthFailure());
      }
      await firebaseUserDataSource.saveUserField(id, field, value);
      return Right(true);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
