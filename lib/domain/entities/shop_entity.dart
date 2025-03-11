import 'dart:typed_data';

import 'package:roll_and_reserve/data/models/shop_model.dart';

class ShopEntity {
  final int id;
  final String address;
  final String name;
  final dynamic logo;
  final String logoId;
  final double averageRaiting;
  final String ownerId;
  final List<int>  tablesShop;
  final List<int> gamesShop;
  final double latitude;
  final double longitude;

  ShopEntity(
      {required this.id,
      required this.name,
      required this.address,
      required this.logo,
      required this.averageRaiting,
      required this.logoId,
      required this.ownerId,
      required this.tablesShop,
      required this.gamesShop,
      required this.latitude,
      required this.longitude});

  ShopModel toShopModel(String? logoId) {
    return ShopModel(
        id: id,
        name: name,
        address: address,
        logo: logo ?? Uint8List(0),
        ownerId: ownerId,
        logoId: logoId ?? "677e565be78534b20cb542b0",
        averageRaiting: averageRaiting,
        tablesShop: tablesShop,
        gamesShop: gamesShop,
        latitude: latitude,
        longitude: longitude);
  }
}
