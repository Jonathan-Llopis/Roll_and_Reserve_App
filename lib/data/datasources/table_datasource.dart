import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/table_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class TableRemoteDataSource {
  Future<List<TableModel>> getAllTables(String token);
  Future<bool> deleteTables(int idTables, String token);
  Future<bool> updateTables(TableModel table, String token);
  Future<bool> createTables(TableModel table, String token);
  Future<List<TableModel>> getAllTablesByShop(int shopId, String token);
}

class TablesRemoteDataSourceImpl implements TableRemoteDataSource {
  final http.Client client;

  TablesRemoteDataSourceImpl(this.client);

  @override
  Future<List<TableModel>> getAllTables(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/tables'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => TableModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la mesa.');
    }
  }

  @override
  Future<bool> deleteTables(int idTables, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/tables/$idTables'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar la mesa.');
    }
  }

  @override
  Future<bool> updateTables(TableModel table, String token) async {
    final response = await client.put(
      Uri.parse('${dotenv.env['BACKEND']}/tables/${table.id}'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(table.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al modificar la mesa: ${response.body}');
    }
  }

  @override
  Future<bool> createTables(TableModel table, String token) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/tables'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(table.toJson()),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al crear el mesa: ${response.body}');
    }
  }
  @override
  Future<List<TableModel>> getAllTablesByShop(int shopId, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/tables/shop/$shopId'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> tableJson = json.decode(response.body);
      return tableJson.map((json) => TableModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las mesas del tienda.');
    }
  }
}
