import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';

abstract class ReserveEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetReservesEvent extends ReserveEvent {}

class GetAllDifficultyEvent extends ReserveEvent {}

class GetAllGameEvent extends ReserveEvent {}

class GetAllCategoryGameEvent extends ReserveEvent {}

class GetReserveEvent extends ReserveEvent {
  final int idReserve;
  GetReserveEvent({required this.idReserve});

  @override
  List<Object?> get props => [idReserve];
}

class GetReserveByDateEvent extends ReserveEvent {
  final DateTime dateReserve;
  final int idTable;
  GetReserveByDateEvent({required this.dateReserve, required this.idTable});

  @override
  List<Object?> get props => [dateReserve, idTable];
}

class CreateReserveEvent extends ReserveEvent {
  final ReserveEntity reserve;
  final String idUser;
  final DateTime dateReserve;
  CreateReserveEvent(
      {required this.reserve, required this.idUser, required this.dateReserve});

  @override
  List<Object?> get props => [reserve, idUser, dateReserve];
}

class DeleteReserveEvent extends ReserveEvent {
  final int idReserve;
  final String idOwner;
  DeleteReserveEvent({required this.idReserve, required this.idOwner});

  @override
  List<Object?> get props => [idReserve];
}

class GetReserveByTableEvent extends ReserveEvent {
  final int idTable;
  GetReserveByTableEvent({required this.idTable});

  @override
  List<Object?> get props => [idTable];
}

class AddUserToReserveEvent extends ReserveEvent {
  final int idReserve;
  final String idUser;
  final int idTable;
  final DateTime dateReserve;
  AddUserToReserveEvent(
      {required this.idReserve,
      required this.idUser,
      required this.idTable,
      required this.dateReserve});

  @override
  List<Object?> get props => [idReserve, idUser, idTable, dateReserve];
}

class DeleteUserOfReserveEvent extends ReserveEvent {
  final int idReserve;
  final String idUser;
  final int idTable;
  final DateTime dateReserve;
  DeleteUserOfReserveEvent(
      {required this.idReserve,
      required this.idUser,
      required this.idTable,
      required this.dateReserve});

  @override
  List<Object?> get props => [idReserve, idUser, idTable, dateReserve];
}

class GetReservesByShopEvent extends ReserveEvent {
  final ShopEntity currentShop;
  final String dateReserve;
  final String startTime;
  final String endTime;
  GetReservesByShopEvent(
      {required this.currentShop, required this.dateReserve, required this.startTime, required this.endTime});

  @override
  List<Object?> get props => [currentShop, dateReserve, startTime, endTime];
}

class GetReserveWithUsers extends ReserveEvent {
  final int idReserve;
  GetReserveWithUsers({required this.idReserve});

  @override
  List<Object?> get props => [idReserve];
}
