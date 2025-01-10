import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

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

class CreateReserveEvent extends ReserveEvent {
  final ReserveEntity reserve;
  final String idUser;
  CreateReserveEvent({required this.reserve, required this.idUser});

  @override
  List<Object?> get props => [reserve];
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
  AddUserToReserveEvent({required this.idReserve, required this.idUser});

  @override
  List<Object?> get props => [idReserve];
}
class DeleteUserOfReserveEvent extends ReserveEvent {
  final int idReserve;
  final String idUser;
  DeleteUserOfReserveEvent({required this.idReserve, required this.idUser});

  @override
  List<Object?> get props => [idReserve];
}

