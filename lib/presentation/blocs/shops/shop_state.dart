import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

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

  factory ShopState.loading(ShopState state) => state.copyWith(isLoading: true,);

  factory ShopState.success(ShopState state) => state.copyWith(isLoading: false,);

  factory ShopState.getShops(ShopState state, List<ShopEntity> shops) => state.copyWith(shops: shops, isLoading: false,);

  factory ShopState.selectedShop(ShopState state, ShopEntity shopSelected) => state.copyWith(shop: shopSelected, isLoading: false,);

  factory ShopState.failure(ShopState state, String errorMessage) => state.copyWith(errorMessage: errorMessage, isLoading: false);

  }
