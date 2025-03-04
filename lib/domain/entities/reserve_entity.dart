import 'package:roll_and_reserve/data/models/reserve_model.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class ReserveEntity {
  final int id;
  final int freePlaces;
  final String dayDate;
  final String horaInicio;
  final String horaFin;
  final String description;
  final String requiredMaterial;
  final int difficultyId;
  final int gameId;
  final String gameName;
  final int tableId;
  final int usersInTables;
  final List<UserEntity>? users;
  final int? shopId;
  final bool isEvent;

  ReserveEntity({
    required this.id,
    required this.freePlaces,
    required this.dayDate,
    required this.horaInicio,
    required this.horaFin,
    required this.description,
    required this.requiredMaterial,
    required this.difficultyId,
    required this.gameId,
    required this.gameName,
    required this.tableId,
    required this.usersInTables,
    this.users,
    this.shopId,
    required this.isEvent,
  });

  ReserveModel toReserveModel() {
    return ReserveModel(
      id: id,
      freePlaces: freePlaces,
      dayDate: dayDate,
      horaInicio: horaInicio,
      horaFin: horaFin,
      description: description,
      requiredMaterial: requiredMaterial,
      difficultyId: difficultyId,
      gameId: gameId,
      gameName: gameName,
      tableId: tableId,
      usersInTables: usersInTables,
      shopId: shopId,
      isEvent: isEvent,
    );
  }
}
