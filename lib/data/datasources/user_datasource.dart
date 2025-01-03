import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:roll_and_reserve/data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel> getValidUser(String email, String token);
  Future<UserModel> getUser(String email, String token);
  Future<String> getValidToken(String email);
}

class UserDatasourceImpl implements UserDatasource {
  final http.Client client;
  UserDatasourceImpl(this.client);
  List<UserModel> usuarios = [];

  @override
  Future<UserModel> getValidUser(
      String email, String token) async {
    final response = await client.get(
      Uri.parse('http://localhost:8000/users'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);

      usuarios = userJson.map((json) => UserModel.fromJson(json)).toList();

      UserModel usuario =
          usuarios.firstWhere((usuario) => usuario.email == email);
         final user = UserModel(
        id: usuario.id,
        email: email,
        role: usuario.role,
        name: usuario.name,
        avatar: usuario.avatar,
        averageRaiting: usuario.averageRaiting
      );
      return user;
    } else {
      throw Exception('Error al cargar usuario');
    }
  }

  @override
  Future<String> getValidToken(String email) async {
    var uri = Uri.http('localhost:8000', '/users/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
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
  Future<UserModel> getUser(String email, String token) async {
    final response = await client.get(
      Uri.parse('http://localhost:8000/users'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);

      usuarios = userJson.map((json) => UserModel.fromJson(json)).toList();

      UserModel usuario =
          usuarios.firstWhere((usuario) => usuario.email == email);
      final user = UserModel(
        id: usuario.id,
        email: email,
        role: usuario.role,
        name: usuario.name,
        avatar: usuario.avatar,
        averageRaiting: usuario.averageRaiting
      );
      return user;
    } else {
      throw Exception('Error al cargar usuarios');
    }
  }
}