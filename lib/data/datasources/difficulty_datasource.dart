import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/difficulty_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class DifficultyRemoteDataSource {
  Future<List<DifficultyModel>> getAllDifficulty(String token);
}

class DifficultyRemoteDataSourceImpl implements DifficultyRemoteDataSource {
  final http.Client client;

  DifficultyRemoteDataSourceImpl(this.client);

  @override
  Future<List<DifficultyModel>> getAllDifficulty(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/difficulties'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => DifficultyModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la difficultad.');
    }
  }
}
