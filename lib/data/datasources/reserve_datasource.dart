import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:roll_and_reserve/data/models/reserve_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';

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
  Future<List<UserModel>> getLastTenPlayers(String idGoogle, String token);
}

class ReservesRemoteDataSourceImpl implements ReserveRemoteDataSource {
  final http.Client client;

  ReservesRemoteDataSourceImpl(this.client);

  @override
/// Fetches all reserves from the backend.
///
/// The [token] is the access token of the user, used to authorize the request.
///
/// Returns a [Future] that resolves to a list of [ReserveModel] if the request is successful.
/// If the status code is 204, returns an empty list indicating no reserves are available.
/// Throws an [Exception] if there is an error during the fetch process.

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
  /// Deletes a reserve from the backend.
  ///
  /// The [idReserves] is the id of the reserve to delete.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the reserve was deleted.
  /// Throws an [Exception] if there is an error during the deletion process.
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
  /// Updates a reserve on the backend.
  ///
  /// The [reserve] parameter is a [ReserveModel] object containing the updated details of the reserve.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the reserve was updated.
  /// Throws an [Exception] if there is an error during the update process.

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
  /// Creates a reserve on the backend.
  ///
  /// The [reserve] parameter is a [ReserveModel] object containing the details of the reserve.
  /// The [token] is the access token of the user, used to authorize the request.
  /// The [idShop] parameter is the id of the shop where the reserve is being created.
  ///
  /// Returns a [Future] that resolves to the id of the created reserve if the request is successful.
  /// If the status code is 201, returns the id of the created reserve.
  /// Throws an [Exception] if there is an error during the creation process.
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
  /// Adds a user to a reserve on the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve to which the user is being added.
  /// The [idUser] parameter is the id of the user being added to the reserve.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 201, returns true indicating the user was added successfully.
  /// Throws an [Exception] if there is an error during the process.

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
  /// Deletes a user from a reserve on the backend.
  ///
  /// The [idReserve] parameter is the id of the reserve from which the user is being deleted.
  /// The [idUser] parameter is the id of the user being deleted from the reserve.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a boolean if the request is successful.
  /// If the status code is 200, returns true indicating the user was deleted successfully.
  /// Throws an [Exception] if there is an error during the deletion process.
  Future<bool> deleteUserToReserve(
      int idReserve, String idUser, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/users/$idUser/reserves/$idReserve'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Error al borrar usuario de la reserva: ${response.body}');
    }
  }

  @override
  /// Gets all reserves for a given date and table.
  ///
  /// The [date] parameter is the date for which to get the reserves, in the format 'YYYY-MM-DD'.
  /// The [token] parameter is the access token of the user, used to authorize the request.
  /// The [idTable] parameter is the id of the table for which to get the reserves.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveModel] if the request is successful.
  /// If the status code is 200, returns the list of reserves.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the retrieval process.
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
  /// Fetches a specific reserve by its ID from the backend.
  ///
  /// The [idReserve] parameter is the ID of the reserve to be fetched.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a [ReserveModel] if the request is successful.
  /// Throws an [Exception] if there is an error during the fetch process.

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
  /// Fetches all reserves of a specific user from the backend.
  ///
  /// The [idUser] parameter is the ID of the user whose reserves are to be fetched.
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveModel] if the request is successful.
  /// If the status code is 200, returns the list of reserves.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the fetch process.
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
  /// Confirms a reserve for a specific user on the backend.
  ///
  /// The [idReserve] parameter is the ID of the reserve to be confirmed.
  /// The [idUser] parameter is the ID of the user for whom the reserve is being confirmed.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a boolean indicating if the confirmation was successful.
  /// If the status code is 200, returns true indicating the reserve was confirmed successfully.
  /// Throws an [Exception] if there is an error during the confirmation process.

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
  /// Creates a reserve event on the backend.
  ///
  /// The [reserve] parameter is a [ReserveModel] object containing the details of the reserve event.
  /// The [token] is the access token of the user, used to authorize the request.
  /// The [idShop] parameter is the id of the shop where the reserve event is being created.
  ///
  /// Returns a [Future] that resolves to the id of the created reserve event if the request is successful.
  /// If the status code is 201, returns the id of the created reserve event.
  /// Throws an [Exception] if there is an error during the creation process.

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
  /// Fetches all reserve events for a specific shop from the backend.
  ///
  /// The [idShop] parameter is the ID of the shop for which to get the reserve events.
  /// The [token] is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a list of [ReserveModel] if the request is successful.
  /// If the status code is 200, returns the list of reserve events.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the fetch process.

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
  @override
  /// Fetches the last ten players that reserved a table from the backend.
  ///
  /// The [idGoogle] parameter is the ID of the user whose last ten players are to be fetched.
  /// The [token] parameter is the access token of the user, used to authorize the request.
  ///
  /// Returns a [Future] that resolves to a list of [UserModel] if the request is successful.
  /// If the status code is 200, returns the list of the last ten players.
  /// If the status code is 204, returns an empty list.
  /// Throws an [Exception] if there is an error during the fetch process.
  Future<List<UserModel>> getLastTenPlayers(String idGoogle, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/reserves/last_ten_players/$idGoogle'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> playersJson = json.decode(response.body);
      return playersJson.map((json) => UserModel.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    }
    else {
      throw Exception('Error al cargar los últimos diez jugadores.');
    }
  }
}
