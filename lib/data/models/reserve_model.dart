import 'package:roll_and_reserve/data/models/functions_for_models.dart';
import 'package:roll_and_reserve/data/models/user_model.dart';
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
  final int gameId;
  final String gameName;
  final int tableId;
  final int usersInTables;
  final List<UserModel>? users;
  final int? shopId;
  final bool isEvent;

  ReserveModel({
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

  factory ReserveModel.fromJson(Map<String, dynamic> json) {
    return ReserveModel(
      id: json['id_reserve'] ?? 0,
      freePlaces: json['total_places'] ?? 0,
      dayDate: getDate(json['hour_start'] ?? ""),
      horaInicio: getHour(json['hour_start'] ?? ""),
      horaFin: getHour(json['hour_end'] ?? ""),
      description: json['description'] ?? "",
      requiredMaterial: json['required_material'] ?? "",
      difficultyId: json['difficulty'] == null
          ? 0
          : json['difficulty']['id_difficulty'] ?? 0,
      gameId: json['reserve_of_game'] == null
          ? 0
          : json['reserve_of_game']['id_game'] ?? 0,
      gameName: json['reserve_of_game'] == null
          ? ""
          : json['reserve_of_game']['name'] ?? "",
      tableId: json['reserve_table'] == null
          ? 0
          : json['reserve_table']['id_table'] ?? 0,
      usersInTables:
          json['users_in_reserve'] != null ? json['userReserves'].length : 0,
      isEvent: json['shop_event'] ?? false,
    );
  }

  factory ReserveModel.fromJsonWithUsers(Map<String, dynamic> json) {
    return ReserveModel(
      id: json['id_reserve'] ?? 0,
      freePlaces: json['total_places'] ?? 0,
      dayDate: getDate(json['hour_start'] ?? ""),
      horaInicio: getHour(json['hour_start'] ?? ""),
      horaFin: getHour(json['hour_end'] ?? ""),
      description: json['description'] ?? "",
      requiredMaterial: json['required_material'] ?? "",
      difficultyId: json['difficulty'] == null
          ? 0
          : json['difficulty']['id_difficulty'] ?? 0,
      gameId: json['reserve_of_game'] == null
          ? 0
          : json['reserve_of_game']['id_game'] ?? 0,
      gameName: json['reserve_of_game'] == null
          ? ""
          : json['reserve_of_game']['name'] ?? "",
      tableId: json['reserve_table'] == null
          ? 0
          : json['reserve_table']['id_table'] ?? 0,
      usersInTables:
          json['users_in_reserve'] != null ? json['userReserves'].length : 0,
      users: json['userReserves'] != null
          ? List<UserModel>.from(json['userReserves'].map((userReserve) =>
              UserModel.fromJsonReserve(
                  userReserve['user'], userReserve['reserva_confirmada'])))
          : null,
      isEvent: json['shop_event'] ?? false,
    );
  }

  factory ReserveModel.fromJsonUsersReserves(Map<String, dynamic> json) {
    return ReserveModel(
      id: json['reserve']['id_reserve'] ?? 0,
      freePlaces: json['reserve']['total_places'] ?? 0,
      dayDate: getDate(json['reserve']['hour_start'] ?? ""),
      horaInicio: getHour(json['reserve']['hour_start'] ?? ""),
      horaFin: getHour(json['reserve']['hour_end'] ?? ""),
      description: json['reserve']['description'] ?? "",
      requiredMaterial: json['reserve']['required_material'] ?? "",
      difficultyId: 0,
      gameId: json['reserve']['reserve_of_game'] == null
          ? 0
          : json['reserve']['reserve_of_game']['id_game'] ?? 0,
      gameName: json['reserve']['reserve_of_game'] == null
          ? ""
          : json['reserve']['reserve_of_game']['name'] ?? "",
      tableId: json['reserve']['reserve_table'] == null
          ? 0
          : json['reserve']['reserve_table']['id_table'] ?? 0,
      usersInTables: json['reserve']['userReserves'] != null
          ? json['reserve']['userReserves'].length
          : 0,
      users: null,
      shopId: json['reserve']['reserve_table'] == null
          ? null
          : json['reserve']['reserve_table']['tables_of_shop']['id_shop'],
      isEvent: json['shop_event'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'total_places': freePlaces,
      'hour_start': getIsoDate(dayDate, horaInicio),
      'hour_end': getIsoDate(dayDate, horaFin),
      'description': description,
      'shop_event': isEvent,
      'required_material': requiredMaterial,
      'difficulty_id': difficultyId,
      'reserve_of_game_id': gameId,
      'game_name': gameName,
      'reserve_table_id': tableId,
    };
  }

  Map<String, dynamic> toJsonEvent() {
    return {
      'id_reserve': id,
      'total_places': freePlaces,
      'hour_start': getIsoDate(dayDate, horaInicio),
      'hour_end': getIsoDate(dayDate, horaFin),
      'description': description,
      'required_material': requiredMaterial,
      'difficulty': difficultyId,
      'reserve_of_game_id': gameId,
      'game_name': gameName,
      'reserve_table_id': tableId,
      'shop_event': true,
      'event_id': "$dayDate-$gameId-$shopId",
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
        gameId: gameId,
        gameName: gameName,
        tableId: tableId,
        usersInTables: usersInTables,
        shopId: shopId,
        isEvent: isEvent);
  }

  ReserveEntity toReserveEntityWithUsers(List<dynamic> avatarUser) {
    return ReserveEntity(
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
        users: users?.asMap().entries.map((entry) {
          return entry.value.toUserEntity(
              avatarUser[entry.key], entry.value.reserveConfirmation);
        }).toList(),
        usersInTables: users!.length,
        isEvent: isEvent);
  }
}
