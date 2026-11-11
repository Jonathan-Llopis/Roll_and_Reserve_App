import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class GetLastTenPlayersEvent extends PlayerEvent {
  final String idGoogle;

  const GetLastTenPlayersEvent({required this.idGoogle});

  @override
  List<Object?> get props => [idGoogle];
}

class AddPlayerToReserveEvent extends PlayerEvent {
  final int idReserve;
  final String idUser;

  const AddPlayerToReserveEvent({
    required this.idReserve,
    required this.idUser,
  });

  @override
  List<Object?> get props => [idReserve, idUser];
}

class RemovePlayerFromReserveEvent extends PlayerEvent {
  final int idReserve;
  final String idUser;

  const RemovePlayerFromReserveEvent({
    required this.idReserve,
    required this.idUser,
  });

  @override
  List<Object?> get props => [idReserve, idUser];
}
