import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/category_game_model.dart';


abstract class CategoryGameRemoteDataSource {
  Future<List<GameCategoryModel>> getAllCategoryGame(String token);

}

class CategoryGameRemoteDataSourceImpl implements CategoryGameRemoteDataSource {
  final http.Client client;

  CategoryGameRemoteDataSourceImpl(this.client);

  @override
  Future<List<GameCategoryModel>> getAllCategoryGame(String token) async {
    final response = await client.get(
      Uri.parse('http://localhost:8000/game-category'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => GameCategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la mesa.');
    }
  }
}
