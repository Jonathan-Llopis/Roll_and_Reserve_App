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
    } else {
      throw Exception('Error al cargar la imagen');
    }
  }

  @override
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
