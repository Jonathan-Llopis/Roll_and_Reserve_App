import 'package:roll_and_reserve/data/models/shop_model.dart';

class ShopEntity {
  final int id;
  final String address;
  final String name;
  final dynamic logo;
  final String logoId;
  final double averageRaiting;
  final String ownerId;

  ShopEntity(
      {required this.id,
      required this.name,
      required this.address,
      required this.logo,
      required this.averageRaiting,
      required this.logoId,
      required this.ownerId});

  ShopModel toShopModel(String? logoId) {
    return ShopModel(
        id: id,
        name: name,
        address: address,
        logo: logo ?? <int>[],
        ownerId: ownerId,
        logoId: logoId ?? "677e565be78534b20cb542b0",
        averageRaiting: averageRaiting,
      );
  }
}
