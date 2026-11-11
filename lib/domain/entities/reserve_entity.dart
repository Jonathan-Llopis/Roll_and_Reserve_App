import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

class ReserveEntity extends Equatable {
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
  final String userReserveId;

  const ReserveEntity({
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
    required this.userReserveId,
  });

  ReserveEntity copyWith({
    int? id,
    int? freePlaces,
    String? dayDate,
    String? horaInicio,
    String? horaFin,
    String? description,
    String? requiredMaterial,
    int? difficultyId,
    int? gameId,
    String? gameName,
    int? tableId,
    int? usersInTables,
    List<UserEntity>? users,
    int? shopId,
    bool? isEvent,
    String? userReserveId,
  }) {
    return ReserveEntity(
      id: id ?? this.id,
      freePlaces: freePlaces ?? this.freePlaces,
      dayDate: dayDate ?? this.dayDate,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      description: description ?? this.description,
      requiredMaterial: requiredMaterial ?? this.requiredMaterial,
      difficultyId: difficultyId ?? this.difficultyId,
      gameId: gameId ?? this.gameId,
      gameName: gameName ?? this.gameName,
      tableId: tableId ?? this.tableId,
      usersInTables: usersInTables ?? this.usersInTables,
      users: users ?? this.users,
      shopId: shopId ?? this.shopId,
      isEvent: isEvent ?? this.isEvent,
      userReserveId: userReserveId ?? this.userReserveId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        freePlaces,
        dayDate,
        horaInicio,
        horaFin,
        description,
        requiredMaterial,
        difficultyId,
        gameId,
        gameName,
        tableId,
        usersInTables,
        users,
        shopId,
        isEvent,
        userReserveId,
      ];
}
