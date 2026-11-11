import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/game_model.dart';
import 'package:roll_and_reserve/data/models/genui_component_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class GameRemoteDataSource {
  Future<List<GameModel>> getAllGame(String token);
  Future<List<GameModel>> searchGameByName(String name, String token);
  Future<RulesAssistResponseModel> askGameRule({
    required String token,
    required String question,
    int? gameId,
    int? bggId,
    String? gameName,
    List<Map<String, String>>? history,
  });
}

class GameRemoteDataSourceImpl implements GameRemoteDataSource {
  final http.Client client;

  GameRemoteDataSourceImpl(this.client);

  @override

  /// Gets all the games.
  ///
  /// The [token] is the access token of the user.
  ///
  /// Throws an [Exception] if the response status code is not 200.
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

  @override

  /// Searches a game by name.
  ///
  /// The [token] is the access token of the user.
  /// The [name] is the name of the game to search.
  ///
  /// Throws an [Exception] if the response status code is not 200 or 204.
  ///
  /// Returns a list of [GameModel] with the games that match the name.
  /// If the list is empty, the method returns an empty list.
  Future<List<GameModel>> searchGameByName(String token, String name) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/games/search/$name'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => GameModel.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Error al buscar los juegos.');
    }
  }

  @override

  /// Resuelve dudas sobre las reglas de un juego con salida en formato GenUI
  Future<RulesAssistResponseModel> askGameRule({
    required String token,
    required String question,
    int? gameId,
    int? bggId,
    String? gameName,
    List<Map<String, String>>? history,
  }) async {
    final String path = gameId != null
        ? '/games/$gameId/rules-assist'
        : bggId != null
            ? '/games/$bggId/rules-assist'
            : '/rules-assistant';

    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}$path'),
      headers: {
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: json.encode({
        'question': question,
        if (gameName != null) 'gameName': gameName,
        if (bggId != null) 'bggId': bggId,
        if (gameId != null) 'gameId': gameId,
        if (history != null) 'history': history,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      return RulesAssistResponseModel.fromJson(responseJson);
    } else {
      throw Exception(
        'Error al consultar las reglas del juego: ${response.statusCode}',
      );
    }
  }
}
