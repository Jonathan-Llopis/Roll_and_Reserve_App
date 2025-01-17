import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/reserve_model.dart';

abstract class ReserveRemoteDataSource {
  Future<List<ReserveModel>> getAllReserves(String token);
  Future<bool> deleteReserves(int idReserves, String token);
  Future<bool> updateReserves(ReserveModel reserve, String token);
  Future<int> createReserves(ReserveModel reserve, String token);
  Future<bool> addUserToReserve(int idReserve, String idUser, String token);
  Future<bool> deleteUserToReserve(int idReserve, String idUser, String token);
}

class ReservesRemoteDataSourceImpl implements ReserveRemoteDataSource {
  final http.Client client;

  ReservesRemoteDataSourceImpl(this.client);

  @override
  Future<List<ReserveModel>> getAllReserves(String token) async {
    final response = await client.get(
      Uri.parse('http://localhost:8000/reserves'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reserveJson = json.decode(response.body);
      return reserveJson.map((json) => ReserveModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las reservas.');
    }
  }

  @override
  Future<bool> deleteReserves(int idReserves, String token) async {
    final response = await client.delete(
      Uri.parse('http://localhost:8000/reserves/$idReserves'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar la reserva.');
    }
  }

  @override
  Future<bool> updateReserves(ReserveModel reserve, String token) async {
    final response = await client.put(
      Uri.parse('http://localhost:8000/reserves/${reserve.id}'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(reserve.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al modificar la reserva: ${response.body}');
    }
  }

  @override
Future<int> createReserves(ReserveModel reserve, String token) async {
  final response = await client.post(
    Uri.parse('http://localhost:8000/reserves'),
    headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    },
    body: json.encode(reserve.toJson()),
  );
  if (response.statusCode == 201) {
    final jsonData = json.decode(response.body);
    return jsonData['id_reserve'];
  } else {
    throw Exception('Error al crear la reserva: ${response.body}');
  }
}


   @override
  Future<bool> addUserToReserve(int idReserve, String idUser, String token) async {
    final response = await client.post(
      Uri.parse('http://localhost:8000/users/$idUser/reserves/$idReserve'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al añadir usuario a la reserva: ${response.body}');
    }
  }

   @override
  Future<bool> deleteUserToReserve(int idReserve, String idUser, String token) async {
    final response = await client.delete(
      Uri.parse('http://localhost:8000/users/$idUser/reserves/$idReserve'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Error al borrar usuario de la reserva: ${response.body}');
    }
  }
}
