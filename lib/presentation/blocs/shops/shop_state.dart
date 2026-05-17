import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

sealed class ShopState extends Equatable {
  final List<ShopEntity>? shops;
  final ShopEntity? shop;
  final Map<String, String>? filterShops;
  final Map<String, dynamic>? totalReservations;
  final Map<String, dynamic>? playerCount;
  final Map<String, dynamic>? peakReservationHours;
  final Map<String, dynamic>? mostPlayedGames;

  const ShopState({
    this.shops,
    this.shop,
    this.filterShops,
    this.totalReservations,
    this.playerCount,
    this.peakReservationHours,
    this.mostPlayedGames,
  });

  bool get isLoading => this is ShopLoading;
  String? get errorMessage =>
      this is ShopFailure ? (this as ShopFailure).errorMessage : null;

  @override
  List<Object?> get props => [
        shops,
        shop,
        filterShops,
        totalReservations,
        playerCount,
        peakReservationHours,
        mostPlayedGames,
      ];
}

class ShopInitial extends ShopState {
  const ShopInitial() : super();
}

class ShopLoading extends ShopState {
  const ShopLoading({
    super.shops,
    super.shop,
    super.filterShops,
    super.totalReservations,
    super.playerCount,
    super.peakReservationHours,
    super.mostPlayedGames,
  });
}

class ShopSuccess extends ShopState {
  const ShopSuccess({
    super.shops,
    super.shop,
    super.filterShops,
    super.totalReservations,
    super.playerCount,
    super.peakReservationHours,
    super.mostPlayedGames,
  });
}

class ShopFailure extends ShopState {
  @override
  final String errorMessage;
  const ShopFailure(
    this.errorMessage, {
    super.shops,
    super.shop,
    super.filterShops,
    super.totalReservations,
    super.playerCount,
    super.peakReservationHours,
    super.mostPlayedGames,
  });

  @override
  List<Object?> get props => [super.props, errorMessage];
}
