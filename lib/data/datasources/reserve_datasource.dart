import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/reserve_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ReserveRemoteDataSource {
  Future<List<ReserveModel>> getAllReserves(String token);
  Future<bool> deleteReserves(int idReserves, String token);
  Future<bool> updateReserves(ReserveModel reserve, String token);
  Future<int> createReserves(ReserveModel reserve, String token, int idShop);
  Future<bool> addUserToReserve(int idReserve, String idUser, String token);
  Future<bool> deleteUserToReserve(int idReserve, String idUser, String token);
  Future<List<ReserveModel>> getAllReservesByDate(
      String date, String token, int idTable);
  Future<ReserveModel> getReserveById(int idReserve, String token);
  Future<List<ReserveModel>> getReservesOfUser(String idUser, String token);
  Future<bool> confirmReserve(int idReserve, String idUser, String token);
  Future<int> createReservesEvent(ReserveModel reserve, String token, int idShop);
  Future<List<ReserveModel>> getEvents(int idShop, String token);
}

class ReservesRemoteDataSourceImpl implements ReserveRemoteDataSource {
  final http.Client client;

  ReservesRemoteDataSourceImpl(this.client);

  @override
  Future<List<ReserveModel>> getAllReserves(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reserves'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reserveJson = json.decode(response.body);
      return reserveJson.map((json) => ReserveModel.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    }
    else {
      throw Exception('Error al cargar las reservas.');
    }
  }

  @override
  Future<bool> deleteReserves(int idReserves, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/$idReserves'),
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
      Uri.parse('${dotenv.env['BACKEND']}/reserves/${reserve.id}'),
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
  Future<int> createReserves(ReserveModel reserve, String token, int idShop) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/$idShop'),
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
  Future<bool> addUserToReserve(
      int idReserve, String idUser, String token) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/users/$idUser/reserves/$idReserve'),
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
  Future<bool> deleteUserToReserve(
      int idReserve, String idUser, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/users/$idUser/reserves/$idReserve'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception(
          'Error al borrar usuario de la reserva: ${response.body}');
    }
  }

  @override
  Future<List<ReserveModel>> getAllReservesByDate(
      String date, String token, int idTable) async {
      
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/date/$date/$idTable'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reserveJson = json.decode(response.body);
      return reserveJson.map((json) => ReserveModel.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    }
    else {
      throw Exception('Error al cargar las reservas por fecha.');
    }
  }

  @override
  Future<ReserveModel> getReserveById(int idReserve, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/$idReserve'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final reserveJson = json.decode(response.body);
      return ReserveModel.fromJsonWithUsers(reserveJson);
    } else {
      throw Exception('Error al cargar la reserva.');
    }
  }

  @override
  Future<List<ReserveModel>> getReservesOfUser(
      String idUser, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/users/$idUser/reserves/'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reserveJson = json.decode(response.body);
      return reserveJson
          .map((json) => ReserveModel.fromJsonUsersReserves(json))
          .toList();
    }else if (response.statusCode == 204) {
      return [];
    } 
    else {
      throw Exception('Error al cargar las reservas por fecha.');
    }
  }

  @override
  Future<bool> confirmReserve(
      int idReserve, String idUser, String token) async {
    final response = await client.put(
      Uri.parse(
          '${dotenv.env['BACKEND']}/users/$idUser/reserves/$idReserve/confirm'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 60));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al confirmar la reserva: ${response.body}');
    }
  }

  @override
  Future<int> createReservesEvent(ReserveModel reserve, String token, int idShop) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/$idShop'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(reserve.toJsonEvent()),
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return jsonData['id_reserve'];
    } else {
      throw Exception('Error al crear la reserva: ${response.body}');
    }
  }

  @override
  Future<List<ReserveModel>> getEvents(int idShop, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/shop_events/$idShop'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> reserveJson = json.decode(response.body);
      return reserveJson.map((json) => ReserveModel.fromJson(json)).toList();
    }else if (response.statusCode == 204) {
      return [];
    }
     else {
      throw Exception('Error al cargar los eventos de la tienda.');
    }
  }
}
