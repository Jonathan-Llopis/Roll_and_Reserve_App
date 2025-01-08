import 'dart:io';
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

  ShopModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.logoId,
      required this.logo,
      required this.averageRaiting,
      required this.ownerId});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id_shop'],
      name: json['name'],
      address: json['address'],
      logoId: json['logo'] ?? "677e565be78534b20cb542b0",
      logo:  <int>[],
      averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? []),
      ownerId:
          json['owner'] != null ? json['owner']['id_google'] ??"0" : "0",
    );
  }

   factory ShopModel.fromJsonCreate(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id_shop'],
      name: json['name'],
      address: json['address'],
      logoId: json['logo'] ?? "677e565be78534b20cb542b0",
      logo:  <int>[],
      averageRaiting: calcularMediaRatings(json['reviews_shop'] ?? []),
      ownerId:
          json['owner'] ?? "0",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'logo': logoId,
      'owner': ownerId
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
        ownerId: ownerId);
  }

  ShopModel addInfo(String newLogoId, int idShop) {
    return ShopModel(
        id: idShop,
        name: name,
        address: address,
        logoId: newLogoId,
        logo: logo ?? <int>[],
        averageRaiting: averageRaiting,
        ownerId: ownerId);
  }
}
