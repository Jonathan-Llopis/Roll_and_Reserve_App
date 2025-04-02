import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'dart:convert';
import 'package:roll_and_reserve/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class UserDatasource {
  Future<List<UserModel>> getUsers(String token);
  Future<UserModel> getValidUser(String id, String token);
  Future<String> getValidToken(String email, String password);
  Future<bool> createUser(UserModel user, String password);
  Future<dynamic> getUserAvatar(String fileId, String token);
  Future<bool> updateUserInfo(UserModel user, String token);
  Future<String> updateAvatar(UserModel user, String token);
  Future<bool> updateTokenNotification(
      String id, String tokenNotificacion, String token);
  Future <bool> updatePassword(String id, String oldPassword, String newPassword, String token);
  Future<List<UserModel>> getAllUsers(String token);

  
}

class UserDatasourceImpl implements UserDatasource {
  final http.Client client;
  UserDatasourceImpl(this.client);
  List<UserModel> usuarios = [];

  @override
  /// Fetches a list of all users from the backend.
  ///
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a list of [UserModel] if the request is successful.
  /// If the status code is 200, returns the list of all users.
  /// Throws an [Exception] if there is an error during the fetch process.
  Future<List<UserModel>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['BACKEND']}/users/'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }

  @override
  /// Fetches a valid user from the backend using their Google ID.
  ///
  /// The [id] parameter is the Google ID of the user to be fetched.
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a [UserModel] if the request is successful.
  /// If the status code is 200, returns the user details as a [UserModel].
  /// Throws an [Exception] if there is an error during the fetch process.

  Future<UserModel> getValidUser(String id, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/users/google/$id'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic userJson = await json.decode(response.body);

      UserModel userModel = UserModel.fromJson(userJson);

      return userModel;
    } else {
      throw Exception('Error al cargar usuario');
    }
  }

  @override
  /// Authenticates a user and retrieves a valid token from the backend.
  ///
  /// The [email] parameter is the user's email address used for authentication.
  /// The [password] parameter is the user's password used for authentication.
  ///
  /// Returns a [Future] that resolves to a [String] token if the authentication is successful.
  /// If the status code is 201, returns the token as a [String].
  /// Throws an [Exception] if the credentials are incorrect or there is an error during the authentication process.

  Future<String> getValidToken(String email, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['BACKEND']}/users/login'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return jsonData['token'];
    } else {
      throw Exception('Error en las credenciales.');
    }
  }

  @override
  /// Creates a user on the backend.
  ///
  /// The [user] parameter is the user's data, including the user's email address, name, username, and role.
  /// The [password] parameter is the user's password.
  ///
  /// Returns a [Future] that resolves to a boolean indicating whether the user was created successfully or not.
  /// If the status code is 201, returns true.
  /// Throws an [Exception] if there is an error during the creation process.
  Future<bool> createUser(UserModel user, String password) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(user.crateToJson(password)),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al crear el usuario: ${response.body}');
    }
  }

  @override
  /// Downloads the avatar image of a user from the backend.
  ///
  /// The [fileId] parameter is the id of the avatar image to be downloaded.
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to the avatar image as a [Uint8List] or a [File] object.
  /// If the status code is 200, returns the avatar image as a [Uint8List] if the platform is web or a [File] object if the platform is not web.
  /// Throws an [Exception] if there is an error during the download process.
  Future<dynamic> getUserAvatar(String fileId, String token) async {
    if (fileId == "") {
      fileId = "67c4bf09ae01906bd75ace8d";
    }
    final response = await http.get(
        Uri.parse('${dotenv.env['BACKEND']}/files/download/$fileId'),
        headers: {
          'authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      if (kIsWeb) {
        return bytes;
      } else {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileId.png';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return file;
      }
    } else {
      throw Exception('Error al cargar la imagen');
    }
  }

  @override
  /// Updates the user information on the backend.
  ///
  /// The [user] parameter contains the user data to be updated.
  /// The [token] parameter is the access token, used for authorization.
  ///
  /// Returns a [Future] that resolves to true if the update is successful (HTTP status code 200).
  /// Throws an [Exception] if there is an error during the update process.

  Future<bool> updateUserInfo(UserModel user, String token) async {
    final response = await client.put(
      Uri.parse('${dotenv.env['BACKEND']}/users/${user.id}'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar el usuario: ${response.body}');
    }
  }

  @override
  /// Updates the avatar of a user on the backend.
  ///
  /// The [user] parameter contains the new avatar information.
  /// The [token] parameter is the access token, used for authorization.
  ///
  /// Returns a [Future] that resolves to the id of the uploaded avatar file if the update is successful (HTTP status code 201).
  /// Throws an [Exception] if there is an error during the update process.
  Future<String> updateAvatar(UserModel user, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['BACKEND']}/files/avatar/${user.id}'),
    );
    request.headers['authorization'] = 'Bearer $token';

    var file = File(user.avatar.path);
    if (!await file.exists()) {
      throw Exception('El archivo no existe: ${user.avatar.path}');
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        user.avatar.path,
        contentType: http_parser.MediaType('image', 'png'),
      ),
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        var id = jsonResponse[0]['id'].toString();
        return id;
      } else {
        throw Exception('Error: Empty response body');
      }
    } else {
      throw Exception(
          'Error al actualizar el avatar del usuario: ${response.statusCode}, Body: ${response.body}');
    }
  }

  @override
  /// Updates the token notification of a user on the backend.
  ///
  /// The [id] parameter is the id of the user whose token is being updated.
  /// The [tokenNotificacion] parameter is the new token notification.
  /// The [token] parameter is the access token, used for authorization.
  ///
  /// Returns a [Future] that resolves to true if the update is successful (HTTP status code 200).
  /// Throws an [Exception] if there is an error during the update process.
  Future<bool> updateTokenNotification(
      String id, String tokenNotificacion, String token) async {
    final response = await client.put(
      Uri.parse('${dotenv.env['BACKEND']}/users/$id/token'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({'token_notificacion': tokenNotificacion}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Error al actualizar el token de notificación: ${response.body}');
    }
  }
  @override
  /// Updates the password of a user on the backend.
  ///
  /// The [id] parameter is the id of the user whose password is being updated.
  /// The [oldPassword] parameter is the user's current password.
  /// The [newPassword] parameter is the user's new password.
  /// The [token] parameter is the access token, used for authorization.
  ///
  /// Returns a [Future] that resolves to true if the update is successful (HTTP status code 200).
  /// Throws an [Exception] if there is an error during the update process.
  Future<bool> updatePassword(String id, String oldPassword, String newPassword, String token) async {
    final response = await client.put(
      Uri.parse('${dotenv.env['BACKEND']}/users/$id/password'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar la contraseña: ${response.body}');
    }
  }

  @override
  /// Gets all users from the backend.
  ///
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a list of [UserModel] if the request is successful.
  /// If the status code is 200, returns the list of all users.
  /// Throws an [Exception] if there is an error during the retrieval process.
  Future<List<UserModel>> getAllUsers(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/users'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener todos los usuarios: ${response.body}');
    }
  }
}
