import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

class ReserveModel {
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
  final List<String> idUsers;

  ReserveModel(
      {required this.id,
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
      required this.idUsers});

  factory ReserveModel.fromJson(Map<String, dynamic> json) {
    return ReserveModel(
      id: json['id_reserve'] ?? 0,
      freePlaces: json['free_places'] ?? 0,
      dayDate: getDate(json['hour_start']?? "") ,
      horaInicio: getHour(json['hour_start'] ?? ""),
      horaFin: getHour(json['hour_end'] ?? ""),
      description: json['description'] ?? "",
      requiredMaterial: json['required_material'] ?? "",
      difficultyId: json['difficulty']== null ? 0 : json['difficulty']['id_difficulty'] ?? 0,
      gameCategoryId: json['reserve_game_category']== null ? 0 : json['reserve_game_category']['id_game_category'] ?? 0,
      gameId: json['reserve_of_game']== null ? 0 : json['reserve_of_game']['id_game'] ?? 0,
      tableId: json['reserve_table']== null ? 0 : json['reserve_table']['id_table'] ?? 0,
      idUsers: crearListaUsuarios(json['users_in_reserve']?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_reserve': id,
      'free_places': freePlaces,
      'hour_start': getIsoDate(dayDate, horaInicio),
      'hour_end':  getIsoDate(dayDate, horaFin),
      'description': description,
      'required_material': requiredMaterial,
      'difficulty': difficultyId,
      'reserve_game_category': gameCategoryId,
      'reserve_of_game': gameId,
      'reserve_table': tableId,
    };
  }

  ReserveEntity toReserveEntity() {
    return ReserveEntity(
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
      idUsers: idUsers,
    );
  }
  
}
