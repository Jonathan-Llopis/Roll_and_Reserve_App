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
  final int gameCategoryId;
  final int gameId;
  final int tableId;
  final int usersInTables;
  final List<UserEntity>? users;

  ReserveEntity({
    required this.id,
    required this.freePlaces,
    required this.dayDate,
    required this.horaInicio,
    required this.horaFin,
    required this.description,
    required this.requiredMaterial,
    required this.difficultyId,
    required this.gameCategoryId,
    required this.gameId,
    required this.tableId,
    required this.usersInTables,
    this.users,
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
      gameCategoryId: gameCategoryId,
      gameId: gameId,
      tableId: tableId,
      usersInTables: usersInTables,
    );
  }
}
