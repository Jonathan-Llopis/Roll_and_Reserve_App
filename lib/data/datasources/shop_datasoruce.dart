import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
    final response = await client.put(
      Uri.parse('${dotenv.env['BACKEND']}/shops/${shops.id}'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: json.encode(shops.toJson()),
    );
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
    request.headers.addAll({
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token',
    });
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        shop.logo,
        filename: 'logo',
      ),
    );
    var response = await request.send();
    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      var id = jsonDecode(responseBody)[0]['id'];
      return id;
    } else {
      throw Exception(
          'Error al actualizar el logo de la tienda: ${response.statusCode}');
    }
  }

  @override
  Future<dynamic> getShopLogo(String fileId, String token) async {
    if (fileId == "") {
      fileId = "678f8573e32f3fa9fd0ed5d6";
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
}
