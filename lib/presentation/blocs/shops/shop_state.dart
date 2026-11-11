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
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ShopState({
    this.shops,
    this.shop,
    this.filterShops,
    this.totalReservations,
    this.playerCount,
    this.peakReservationHours,
    this.mostPlayedGames,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  bool get isLoading => this is ShopLoading;
  String? get errorMessage =>
      this is ShopFailure ? (this as ShopFailure).errorMessage : null;

  ShopState copyWith({
    List<ShopEntity>? shops,
    ShopEntity? shop,
    Map<String, String>? filterShops,
    Map<String, dynamic>? totalReservations,
    Map<String, dynamic>? playerCount,
    Map<String, dynamic>? peakReservationHours,
    Map<String, dynamic>? mostPlayedGames,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    if (this is ShopLoading) {
      return ShopLoading(
        shops: shops ?? this.shops,
        shop: shop ?? this.shop,
        filterShops: filterShops ?? this.filterShops,
        totalReservations: totalReservations ?? this.totalReservations,
        playerCount: playerCount ?? this.playerCount,
        peakReservationHours: peakReservationHours ?? this.peakReservationHours,
        mostPlayedGames: mostPlayedGames ?? this.mostPlayedGames,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
    } else if (this is ShopFailure) {
      return ShopFailure(
        (this as ShopFailure).errorMessage,
        shops: shops ?? this.shops,
        shop: shop ?? this.shop,
        filterShops: filterShops ?? this.filterShops,
        totalReservations: totalReservations ?? this.totalReservations,
        playerCount: playerCount ?? this.playerCount,
        peakReservationHours: peakReservationHours ?? this.peakReservationHours,
        mostPlayedGames: mostPlayedGames ?? this.mostPlayedGames,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
    } else {
      return ShopSuccess(
        shops: shops ?? this.shops,
        shop: shop ?? this.shop,
        filterShops: filterShops ?? this.filterShops,
        totalReservations: totalReservations ?? this.totalReservations,
        playerCount: playerCount ?? this.playerCount,
        peakReservationHours: peakReservationHours ?? this.peakReservationHours,
        mostPlayedGames: mostPlayedGames ?? this.mostPlayedGames,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
    }
  }

  @override
  List<Object?> get props => [
        shops,
        shop,
        filterShops,
        totalReservations,
        playerCount,
        peakReservationHours,
        mostPlayedGames,
        currentPage,
        hasReachedMax,
        isLoadingMore,
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
    super.currentPage,
    super.hasReachedMax,
    super.isLoadingMore,
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
    super.currentPage,
    super.hasReachedMax,
    super.isLoadingMore,
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
    super.currentPage,
    super.hasReachedMax,
    super.isLoadingMore,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
