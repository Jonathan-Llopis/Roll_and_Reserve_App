import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShopEntity extends Equatable {
  final int id;
  final String address;
  final String name;
  final dynamic logo;
  final String logoId;
  final double averageRaiting;
  double get averageRating => averageRaiting;
  final String ownerId;
  final List<int> tablesShop;
  final List<int> gamesShop;
  final double latitude;
  final double longitude;

  String get logoUrl {
    if (logoId.isEmpty || logoId == '67c4bf45ae01906bd75ace8f' || logoId == '0') {
      return '';
    }
    final backend = (dotenv.isInitialized ? dotenv.env['BACKEND'] : null) ?? 'http://localhost:3000';
    return '$backend/files/download/$logoId';
  }

  const ShopEntity({
    required this.id,
    required this.name,
    required this.address,
    this.logo,
    required this.averageRaiting,
    required this.logoId,
    required this.ownerId,
    required this.tablesShop,
    required this.gamesShop,
    required this.latitude,
    required this.longitude,
  });

  ShopEntity copyWith({
    int? id,
    String? name,
    String? address,
    dynamic logo,
    double? averageRaiting,
    String? logoId,
    String? ownerId,
    List<int>? tablesShop,
    List<int>? gamesShop,
    double? latitude,
    double? longitude,
  }) {
    return ShopEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      averageRaiting: averageRaiting ?? this.averageRaiting,
      logoId: logoId ?? this.logoId,
      ownerId: ownerId ?? this.ownerId,
      tablesShop: tablesShop ?? this.tablesShop,
      gamesShop: gamesShop ?? this.gamesShop,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        logo,
        averageRaiting,
        logoId,
        ownerId,
        tablesShop,
        gamesShop,
        latitude,
        longitude,
      ];
}
