class ShopEntity {
  final int id;
  final String address;
  final String name;
  final dynamic logo;
  final String logoId;
  final double averageRaiting;
  final String ownerId;
  final List<int> tablesShop;
  final List<int> gamesShop;
  final double latitude;
  final double longitude;

  ShopEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.logo,
    required this.averageRaiting,
    required this.logoId,
    required this.ownerId,
    required this.tablesShop,
    required this.gamesShop,
    required this.latitude,
    required this.longitude,
  });
}
