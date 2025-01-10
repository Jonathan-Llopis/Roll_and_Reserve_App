import 'package:roll_and_reserve/domain/entities/game_entity.dart';

class GameModel {
  final int id;
  final String description;

  GameModel({
    required this.id,
    required this.description,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id_game'],
      description: json['name']??"",
    );
  }
  GameEntity toGameEntity() {
    return GameEntity(
      id: id,
      description: description,
    );
  }
}
