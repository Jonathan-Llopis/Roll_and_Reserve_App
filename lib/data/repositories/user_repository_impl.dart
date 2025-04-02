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
  /// Signs in a user with Google authentication.
  ///
  /// If the user is not registered in the app, it registers the user.
  ///
  /// On the web, this uses the Google Sign In popup. On mobile, this uses the
  /// Google Sign In SDK to sign in the user.
  ///
  /// Returns a [UserEntity] with the signed in user's data.
  ///
  /// Throws a [FirebaseAuthException] if the sign in fails.
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
  /// Signs in a user with the given email and password.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [UserEntity] with the signed in user's data, or an [AuthFailure].
  ///
  /// The [Future] will throw an [Exception] if there is an error during the sign in process.
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
  /// Signs up a new user with the given email, password, name, and username.
  ///
  /// Registers the user in the Firebase authentication and the Firestore database,
  /// stores the user credentials in shared preferences, and creates a user record
  /// on the backend.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [UserEntity] with
  /// the signed-up user's data, or an [AuthFailure] if the sign-up process fails.

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
  /// Checks if a user is currently logged in by verifying the presence of a stored user ID
  /// and token in shared preferences.
  ///
  /// Retrieves the user's data from the backend using the stored ID and token,
  /// including the user's notifications and avatar.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [UserEntity] with the
  /// user's data if logged in, or an [AuthFailure] if there is no stored user ID or if
  /// any error occurs during the process.

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
  /// Retrieves the information of a user by their ID.
  ///
  /// The [idUser] parameter is the ID of the user to be retrieved.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [UserEntity] with the user's data, or an [AuthFailure] if there is an error during the process.
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
  /// Logs out the current user by removing the stored user ID, email, and token,
  /// and updating the user's token notification on the backend.
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [void] if the
  /// logout is successful, or an [AuthFailure] if there is an error during the
  /// process.
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
  /// Sends a password reset email to the given email address.
  ///
  /// This method will attempt to send an email to the user with a link to reset their
  /// password. The user will not be signed out of their current session.
  ///
  /// Returns a [Future] that resolves to an [Either] containing [void] if the email is
  /// successfully sent, or an [AuthFailure] if there is an error during the process.

  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  /// Checks if the given email address is already used in the system.
  ///
  /// Queries the Firestore data source to determine if a user with the given
  /// [email] exists.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// email is already in use, or `false` if it is available. In case of an
  /// error, it returns an [AuthFailure].
  Future<Either<Failure, bool>> isEmailUsed(String email) async {
    try {
      bool isUsed = await firebaseUserDataSource.isEmailUsed(email);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  /// Checks if a username is already used in the system.
  ///
  /// Queries the backend data source to determine if a user with the given
  /// [name] exists.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// username is already in use, or `false` if it is available. In case of an
  /// error, it returns an [AuthFailure].

  Future<Either<Failure, bool>> isNameUsed(String name) async {
    try {
      bool isUsed = await firebaseUserDataSource.isNameUsed(name);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  /// Updates the information of a user.
  ///
  /// This method updates the user's information in both the Firestore database
  /// and the backend. It first updates the user's name, role, and notifications
  /// in Firestore. If the user has an avatar, it updates the avatar on the backend
  /// and retrieves the avatar ID, which is then included in the user model.
  ///
  /// The [user] parameter is the user entity containing the updated data.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// update is successful, or an [AuthFailure] if an error occurs.

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
  /// Updates the password of the currently signed in user.
  ///
  /// The [password] parameter is the new password of the user.
  /// The [oldPassword] parameter is the current password of the user.
  ///
  /// This method first updates the password in the Firestore database, and then
  /// updates the password on the backend. The user must have previously signed
  /// in to use this method.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// update is successful, or an [AuthFailure] if an error occurs.
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
  /// Validates the provided password for the currently signed-in user.
  ///
  /// This method retrieves the user's email from shared preferences and uses
  /// it to validate the provided password against the stored password in
  /// the data source.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if
  /// the password is valid, or an [AuthFailure] if an error occurs during
  /// validation.

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
  /// Gets a list of all users from the remote server.
  ///
  /// The function first calls the [UserDatasource.getUsers] method to retrieve a list of [UserModel] from the backend.
  /// Then, it uses the [UserDatasource.getUserAvatar] method to retrieve the avatar of each user from the backend, and
  /// maps the results to a list of [UserEntity].
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [List] of [UserEntity] if the request is successful.
  /// If the request fails, returns a [Left] containing an [AuthFailure].
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
  /// Updates the token notification for the user in the backend.
  ///
  /// The [id] parameter is the ID of the user whose token notification is being updated.
  /// The [tokenNotification] parameter is the new token notification string.
  ///
  /// This method retrieves the stored access token from shared preferences and
  /// calls the [UserDatasource.updateTokenNotification] method to update the token
  /// notification on the backend.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// update is successful, or an [AuthFailure] if an error occurs during the process.

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
  /// Updates a field in a user document in the Firestore database.
  ///
  /// The user is identified by its [id].
  /// The field to update is identified by [fieldName].
  /// The value of the field is set to [value].
  ///
  /// This method retrieves the stored access token from shared preferences and
  /// calls the [FirebaseUserDatasource.saveUserField] method to update the field
  /// on the backend.
  ///
  /// Returns a [Future] that resolves to an [Either] containing `true` if the
  /// update is successful, or an [AuthFailure] if an error occurs during the process.
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
