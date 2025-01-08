import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class ShopState {
  final bool isLoading;
  final int? idShop;
  final String? errorMessage;
  final List<ShopEntity>? shops;
  final ShopEntity? shop;

  const ShopState(
      {this.isLoading = false,
      this.idShop,  
      this.errorMessage,
      this.shops,
      this.shop
      });

  ShopState copyWith({
    bool? isLoading,
    int? idShop,
    String? errorMessage,
    List<ShopEntity>? shops,
    ShopEntity? shop
  }) {
    return ShopState(
        isLoading: isLoading ?? this.isLoading,
        idShop: idShop ?? this.idShop,
        errorMessage: errorMessage ?? this.errorMessage,
        shops: shops ?? this.shops,
        shop: shop ?? this.shop
        );
  }

    factory ShopState.initial() => const ShopState();

    factory ShopState.loading() => const ShopState(isLoading: true);

    factory ShopState.success() => const ShopState();

    factory ShopState.getShops(List<ShopEntity> shops) => ShopState(shops: shops);

    factory ShopState.selectedShop(ShopEntity shopSelected) => ShopState(shop: shopSelected);

    factory ShopState.failure(String errorMessage) =>
        ShopState(errorMessage: errorMessage);

}
