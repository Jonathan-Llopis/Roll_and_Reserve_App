import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
}

class UserDatasourceImpl implements UserDatasource {
  final http.Client client;
  UserDatasourceImpl(this.client);
  List<UserModel> usuarios = [];

  @override
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
  Future<String> updateAvatar(UserModel user, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['BACKEND']}/files/avatar/${user.id}'),
    );
    request.headers['authorization'] = 'Bearer $token';
    final bytes = await File(user.avatar.path).readAsBytes();
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'avatar',
      ),
    );
    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      var id = jsonDecode(responseBody)[0]['id'];
      return id;
    } else {
      throw Exception(
          'Error al actualizar el avatar del usuario: ${response.statusCode}');
    }
  }

  @override
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
}
