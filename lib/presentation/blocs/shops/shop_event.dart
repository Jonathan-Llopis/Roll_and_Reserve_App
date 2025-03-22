import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

abstract class ShopEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetShopsEvent extends ShopEvent {}

class GetShopEvent extends ShopEvent {
  final int idShop;  
  GetShopEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class CreateShopEvent extends ShopEvent {
  final ShopEntity shop;
  CreateShopEvent({required this.shop});

  @override
  List<Object?> get props => [shop];
}

class UpdateShopEvent extends ShopEvent {
  final ShopEntity shop;
  UpdateShopEvent({required this.shop});

  @override
  List<Object?> get props => [shop];
}

class DeleteShopEvent extends ShopEvent {
  final int idShop;
  final String idOwner;
  DeleteShopEvent({required this.idShop, required this.idOwner});

  @override
  List<Object?> get props => [idShop];
}

class GetShopsByOwnerEvent extends ShopEvent {
  final String owner;
  GetShopsByOwnerEvent({required this.owner});

  @override
  List<Object?> get props => [owner];
}

class GetShopByFilterEvent extends ShopEvent {
  final String? name;
  final String? direction;

  GetShopByFilterEvent({this.name, this.direction});

   @override
  List<Object?> get props => [name, direction];
}

class ClearFilterEvent extends ShopEvent {}

class GetMostPlayedGamesEvent extends ShopEvent {
  final int idShop;

  GetMostPlayedGamesEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class GetTotalReservationsEvent extends ShopEvent {
  final int idShop;

  GetTotalReservationsEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class GetPlayerCountEvent extends ShopEvent {
  final int idShop;

  GetPlayerCountEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class GetPeakReservationHoursEvent extends ShopEvent {
  final int idShop;

  GetPeakReservationHoursEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}
