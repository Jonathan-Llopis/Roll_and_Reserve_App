import 'package:roll_and_reserve/domain/entities/game_entity.dart';

class GameModel {
  final int id;
  final String description;
  final String? name;
  final int? bggId;

  GameModel({
    required this.id,
    required this.description,
    this.name,
    this.bggId,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    final parsedId = json['id_game'] is int
        ? json['id_game'] as int
        : int.tryParse(json['id_game']?.toString() ?? '') ?? 0;

    final parsedBggId = json['bgg_id'] is int
        ? json['bgg_id'] as int
        : int.tryParse(json['bgg_id']?.toString() ?? '');

    final gameName = json['name']?.toString() ?? json['description']?.toString() ?? '';
    final gameDesc = json['description']?.toString() ?? json['name']?.toString() ?? '';

    return GameModel(
      id: parsedId,
      description: gameDesc,
      name: gameName,
      bggId: parsedBggId,
    );
  }

  GameEntity toGameEntity() {
    return GameEntity(
      id: id,
      description: description,
      name: name,
      bggId: bggId,
    );
  }
}
