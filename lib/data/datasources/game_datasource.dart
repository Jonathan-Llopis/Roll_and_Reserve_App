import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/game_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class GameRemoteDataSource {
  Future<List<GameModel>> getAllGame(String token);
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final http.Client client;

  GameRemoteDataSourceImpl(this.client);

  @override
  Future<List<GameModel>> getAllGame(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/games'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => GameModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los juegos.');
    }
  }
}
