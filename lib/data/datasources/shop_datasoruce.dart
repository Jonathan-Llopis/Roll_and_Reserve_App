import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:roll_and_reserve/data/models/shop_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ShopRemoteDataSource {
  Future<List<ShopModel>> getAllShops(String token);
  Future<bool> deleteShops(int idShops, String token);
  Future<bool> updateShops(ShopModel shops, String token);
  Future<ShopModel> createShops(ShopModel shops, String token);
  Future<String> updateLogo(ShopModel shops, String token);
  Future<dynamic> getShopLogo(String fileId, String token);
  Future<ShopModel> getShop(int id, String token);
  Future<List<ShopModel>> getShopsByOwner(String ownerId, String token);
  Future<List<dynamic>> getMostPlayedGames(
      int idShop, String startTime, String endTime, String token);
  Future<int> getTotalReservations(
      int idShop, String startTime, String endTime, String token);
  Future<int> getPlayerCount(
      int idShop, String startTime, String endTime, String token);
  Future<List<dynamic>> getPeakReservationHours(
      int idShop, String startTime, String endTime, String token);
}

class ShopsRemoteDataSourceImpl implements ShopRemoteDataSource {
  final http.Client client;

  ShopsRemoteDataSourceImpl(this.client);

  @override
/// Fetches all shops from the backend.
///
/// The [token] is the access token required for authorization.
///
/// Returns a [Future] that resolves to a list of [ShopModel] if the request
/// is successful (HTTP status code 200).
///
/// Throws an [Exception] if there is an error during the request or if the
/// response status code is not 200.

  Future<List<ShopModel>> getAllShops(String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/shops'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> shopsJson = json.decode(response.body);
      return shopsJson.map((json) => ShopModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar la tienda.');
    }
  }

  @override
  /// Fetches a shop from the backend.
  ///
  /// The [id] is the identifier of the shop to be fetched.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a [ShopModel] if the request
  /// is successful (HTTP status code 200).
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 200.
  Future<ShopModel> getShop(int id, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/shops/$id'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic shopJson = json.decode(response.body);
      return ShopModel.fromJson(shopJson);
    } else {
      throw Exception('Error al cargar la tienda.');
    }
  }

  @override
  /// Fetches the shops owned by [ownerId] from the backend.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a list of [ShopModel] if the request
  /// is successful (HTTP status code 200).
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 200.
  Future<List<ShopModel>> getShopsByOwner(String ownerId, String token) async {
    final response = await client.get(
      Uri.parse('${dotenv.env['BACKEND']}/shops/owner/$ownerId'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> shopsJson = json.decode(response.body);
      return shopsJson.map((json) => ShopModel.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Error al cargar las tiendas del propietario.');
    }
  }

  @override
  /// Deletes the shop with the specified [idShops] from the backend.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a boolean indicating whether the
  /// request is successful (HTTP status code 200).
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 200.
  Future<bool> deleteShops(int idShops, String token) async {
    final response = await client.delete(
      Uri.parse('${dotenv.env['BACKEND']}/shops/$idShops'),
      headers: {
        'authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al eliminar la tienda.');
    }
  }

  @override
  /// Updates the shop with the given [shops] model on the backend.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Sends a PUT request to the backend to update the shop details specified
  /// in [shops]. The request will be made to the endpoint specified by the
  /// shop's ID.
  ///
  /// Returns a [Future] that resolves to `true` if the request is successful
  /// (HTTP status code 200).
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 200.

  Future<bool> updateShops(ShopModel shops, String token) async {
    final response = await client
        .put(
          Uri.parse('${dotenv.env['BACKEND']}/shops/${shops.id}'),
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token',
          },
          body: json.encode(shops.toJson()),
        )
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al modificar la tienda: ${response.body}');
    }
  }

  @override
  /// Creates a new shop on the backend.
  ///
  /// The [shops] parameter is the shop to be created.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a [ShopModel] if the request is
  /// successful (HTTP status code 201).
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 201.
  Future<ShopModel> createShops(ShopModel shops, String token) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/shops'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(shops.toJson()),
    );
    if (response.statusCode == 201) {
      final dynamic shopJson = await json.decode(response.body);

      ShopModel shopModel = ShopModel.fromJsonCreate(shopJson);

      return shopModel;
    } else {
      throw Exception('Error al crear el tienda: ${response.body}');
    }
  }

  @override
  /// Updates the logo of a shop on the backend.
  ///
  /// The [shop] parameter is a [ShopModel] containing the shop details, including
  /// the logo file path to be uploaded.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a [String] representing the ID of the updated logo
  /// if the request is successful (HTTP status code 201).
  ///
  /// Throws an [Exception] if the logo file does not exist, if there is an error during
  /// the request, or if the response status code is not 201.

  Future<String> updateLogo(ShopModel shop, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${dotenv.env['BACKEND']}/files/logo/${shop.id}'),
    );
    request.headers['authorization'] = 'Bearer $token';

    var file = File(shop.logo.path);
    if (!await file.exists()) {
      throw Exception('El archivo no existe: ${shop.logo.path}');
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        shop.logo.path,
        contentType: MediaType('image', 'png'),
      ),
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        var jsonResponse = jsonDecode(response.body);
        var id = jsonResponse[0]['id'].toString();
        return id;
      } else {
        throw Exception('Error: Empty response body');
      }
    } else {
      throw Exception(
          'Error al actualizar el logo de la tienda: ${response.statusCode}, Body: ${response.body}');
    }
  }

  @override
  /// Fetches the logo of a shop from the backend.
  ///
  /// The [fileId] is the identifier of the logo file to be fetched. If an empty
  /// string is provided, a default file ID is used.
  ///
  /// The [token] is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to the logo file. On web platforms, it returns
  /// a [Uint8List] of the logo image bytes. On other platforms, it returns a [File]
  /// object pointing to the temporary directory where the logo is saved.
  ///
  /// If the file is not found (HTTP status code 404), it returns `null`.
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 200 or 404.

  Future<dynamic> getShopLogo(String fileId, String token) async {
    if (fileId == "") {
      fileId = "67c4bf45ae01906bd75ace8f";
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
    } else if (response.statusCode == 404) {
      return null;

    } 
    else {
      throw Exception('Error al cargar la imagen');
    }
  }

  @override
  /// Fetches the most played games for a given shop and time period.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch the
  /// most played games.
  ///
  /// The [startTime] and [endTime] parameters are the start and end times of the
  /// time period for which to fetch the most played games.
  ///
  /// The [token] parameter is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a list of objects containing the game
  /// identifiers, names and play counts. The play counts are strings, so the
  /// caller is responsible for parsing them as integers.
  ///
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 201.
  Future<List<dynamic>> getMostPlayedGames(
      int idShop, String startTime, String endTime, String token) async {
    final response = await client.post(
      Uri.parse(
          '${dotenv.env['BACKEND']}/shops/shop/$idShop/stats/most-played-games'),
      headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 201) {
      final List<dynamic> gamesJson = json.decode(response.body);
      return gamesJson
          .map((json) => {
                'id_game': json['id_game'],
                'name': json['name'],
                'play_count': int.parse(json['play_count'])
              })
          .toList();
    } else {
      throw Exception('Error al obtener los juegos más jugados.');
    }
  }

  @override
  /// Gets the total number of reservations for a given shop and time period.
  ///
  /// The [idShop] parameter is the identifier of the shop for which to fetch the
  /// total number of reservations.
  /// The [startTime] and [endTime] parameters are strings representing the
  /// start and end dates of the time period for which to fetch the total number
  /// of reservations, respectively, in the format 'YYYY-MM-DD'.
  /// The [token] parameter is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to the total number of reservations for the
  /// given shop and time period if the request is successful.
  /// If the status code is 201, returns the total number of reservations.
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 201.
  Future<int> getTotalReservations(
      int idShop, String startTime, String endTime, String token) async {
    final response = await client.post(
      Uri.parse(
          '${dotenv.env['BACKEND']}/shops/shop/$idShop/stats/total-reservations'),
      headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return int.parse(jsonResponse[0]['total_reservations']);
    } else {
      throw Exception('Error al obtener el total de reservas.');
    }
  }

  @override
  /// Retrieves the player count for a specific shop and time period.
  ///
  /// The [idShop] parameter represents the identifier of the shop for which to
  /// retrieve the player count.
  /// The [startTime] and [endTime] parameters define the time range for which
  /// to get the player count, formatted as strings.
  /// The [token] parameter is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to the total number of players counted
  /// for the specified shop and time period if the request is successful.
  /// If the status code is 201, returns the player count.
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 201.

  Future<int> getPlayerCount(
      int idShop, String startTime, String endTime, String token) async {
    final response = await client.post(
      Uri.parse('${dotenv.env['BACKEND']}/shops/shop/$idShop/stats/player-count'),
      headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return int.parse(jsonResponse[0]['player_count']);
    } else {
      throw Exception('Error al obtener el conteo de jugadores.');
    }
  }

  @override
  /// Retrieves the peak reservation hours for a specific shop and time period.
  ///
  /// The [idShop] parameter represents the identifier of the shop for which to
  /// retrieve the peak reservation hours.
  /// The [startTime] and [endTime] parameters define the time range for which
  /// to get the peak reservation hours, formatted as strings.
  /// The [token] parameter is the access token required for authorization.
  ///
  /// Returns a [Future] that resolves to a list of objects containing the hour
  /// and reservation count for each peak reservation period if the request is
  /// successful.
  /// Throws an [Exception] if there is an error during the request or if the
  /// response status code is not 201.

  Future<List<dynamic>> getPeakReservationHours(
      int idShop, String startTime, String endTime, String token) async {
    final response = await client.post(
      Uri.parse(
          '${dotenv.env['BACKEND']}/shops/shop/$idShop/stats/peak-reservation-hours'),
      headers: {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'startTime': startTime,
        'endTime': endTime,
      }),
    );

    if (response.statusCode == 201) {
      final List<dynamic> hoursJson = json.decode(response.body);
      return hoursJson
          .map((json) => {
                'hour': json['hour'],
                'reservation_count': int.parse(json['reservation_count'])
              })
          .toList();
    } else {
      throw Exception('Error al obtener las horas pico de reservas.');
    }
  }
}
