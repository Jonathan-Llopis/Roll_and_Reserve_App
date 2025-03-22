import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

class ShopState {
  final bool isLoading;
  final int? idShop;
  final String? errorMessage;
  final List<ShopEntity>? shops;
  final ShopEntity? shop;
  final Map<String, String>? filterShops;
  final Map<String, dynamic>? totalReservations;
  final Map<String, dynamic>? playerCount;
  final Map<String, dynamic>? peakReservationHours;
  final Map<String, dynamic>? mostPlayedGames;

  const ShopState(
      {this.isLoading = false,
      this.idShop,
      this.errorMessage,
      this.shops,
      this.shop,
      this.filterShops,
      this.totalReservations,
      this.playerCount,
      this.peakReservationHours,
      this.mostPlayedGames});

  ShopState copyWith({
    bool? isLoading,
    int? idShop,
    String? errorMessage,
    List<ShopEntity>? shops,
    ShopEntity? shop,
    Map<String, String>? filterShops,
    Map<String, dynamic>? totalReservations,
    Map<String, dynamic>? playerCount,
    Map<String, dynamic>? peakReservationHours,
    Map<String, dynamic>? mostPlayedGames,
  }) {
    return ShopState(
        isLoading: isLoading ?? this.isLoading,
        idShop: idShop ?? this.idShop,
        errorMessage: errorMessage,
        shops: shops ?? this.shops,
        shop: shop ?? this.shop,
        filterShops: filterShops ?? this.filterShops,
        totalReservations: totalReservations ?? this.totalReservations,
        playerCount: playerCount ?? this.playerCount,
        peakReservationHours: peakReservationHours ?? this.peakReservationHours,
        mostPlayedGames: mostPlayedGames ?? this.mostPlayedGames);
  }

  factory ShopState.initial() => const ShopState();

  factory ShopState.loading(ShopState state) =>
      state.copyWith(isLoading: true, errorMessage: null);

  factory ShopState.success(ShopState state) =>
      state.copyWith(isLoading: false, errorMessage: null);

  factory ShopState.getShops(ShopState state, List<ShopEntity> shops) =>
      state.copyWith(shops: shops, isLoading: false, errorMessage: null);

  factory ShopState.selectedShop(ShopState state, ShopEntity shopSelected) =>
      state.copyWith(shop: shopSelected, isLoading: false, errorMessage: null);

  factory ShopState.failure(ShopState state, String errorMessage) =>
      state.copyWith(errorMessage: errorMessage, isLoading: false);

  factory ShopState.filterShops(ShopState state,
          Map<String, String> filterShops, List<ShopEntity> shops) =>
      state.copyWith(
          filterShops: filterShops,
          shops: shops,
          isLoading: false,
          errorMessage: null);

  factory ShopState.clearFilter(ShopState state) =>
      state.copyWith(filterShops: {});

  factory ShopState.totalReservations(
          ShopState state, Map<String, dynamic> totalReservations) =>
      state.copyWith(
          totalReservations: totalReservations,
          isLoading: false,
          errorMessage: null);

  factory ShopState.playerCount(
          ShopState state, Map<String, dynamic> playerCount) =>
      state.copyWith(
          playerCount: playerCount, isLoading: false, errorMessage: null);

  factory ShopState.peakReservationHours(
          ShopState state, Map<String, dynamic> peakReservationHours) =>
      state.copyWith(
          peakReservationHours: peakReservationHours,
          isLoading: false,
          errorMessage: null);

  factory ShopState.mostPlayedGames(
          ShopState state, Map<String, dynamic> mostPlayedGames) =>
      state.copyWith(
          mostPlayedGames: mostPlayedGames,
          isLoading: false,
          errorMessage: null);
}
