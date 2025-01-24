import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

class ShopModel {
  final int id;
  final String address;
  final String name;
  final String logoId;
  final dynamic logo;
  final double averageRaiting;
  final String ownerId;
  final List<int> tablesShop;
  final List<int> gamesShop;
  final double latitude;
  final double longitude;

  ShopModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.logoId,
      required this.logo,
      required this.averageRaiting,
      required this.ownerId,
      required this.tablesShop,
      required this.gamesShop,
      required this.latitude,
      required this.longitude});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
        id: json['id_shop'],
        name: json['name'],
        address: json['address'],
        logoId: json['logo'] ?? "678f8573e32f3fa9fd0ed5d6",
        logo: <int>[],
        averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? []),
        ownerId:
            json['owner'] != null ? json['owner']['id_google'] ?? "0" : "0",
        tablesShop: calcularMesasTienda(json['tables_in_shop'] ?? []),
        gamesShop: crearListaJuegos(json['games'] ?? []),
        latitude: json['latitud'] ?? 0.0,
        longitude: json['longitud'] ?? 0.0);
  }

  factory ShopModel.fromJsonCreate(Map<String, dynamic> json) {
    return ShopModel(
        id: json['id_shop'],
        name: json['name'],
        address: json['address'],
        logoId: json['logo'] ?? "678f8573e32f3fa9fd0ed5d6",
        logo: <int>[],
        averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? []),
        ownerId: json['owner'] ?? "0",
        tablesShop: calcularMesasTienda(json['tables_shop'] ?? []),
        gamesShop: crearListaJuegos(json['games'] ?? []),
        latitude: json['latitud'] ?? 0.0,
        longitude: json['longitud'] ?? 0.0);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'logo': logoId,
      'owner': ownerId,
      'latitud': latitude.toString(),
      'longitud': longitude.toString()
    };
  }

  ShopEntity toShopEntity(dynamic logoFile) {
    return ShopEntity(
        id: id,
        name: name,
        address: address,
        logoId: logoId,
        logo: logoFile,
        averageRaiting: averageRaiting,
        ownerId: ownerId,
        tablesShop: tablesShop,
        gamesShop: gamesShop,
        latitude: latitude,
        longitude: longitude);
  }

  ShopModel addInfo(String newLogoId, int idShop) {
    return ShopModel(
        id: idShop,
        name: name,
        address: address,
        logoId: newLogoId,
        logo: logo ?? <int>[],
        averageRaiting: averageRaiting,
        ownerId: ownerId,
        tablesShop: tablesShop,
        gamesShop: gamesShop,
        latitude: latitude,
        longitude: longitude);
  }
}
