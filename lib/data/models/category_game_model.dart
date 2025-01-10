import 'package:roll_and_reserve/domain/entities/category_game_entity.dart';

class GameCategoryModel {
  final int id;
  final String description;

  GameCategoryModel({
    required this.id,
    required this.description,
  });

  factory GameCategoryModel.fromJson(Map<String, dynamic> json) {
    return GameCategoryModel(
      id: json['id_game_category'],
      description: json['description'],
    );
  }

  GameCategoryEntity toGameCategoryEntity() {
    return GameCategoryEntity(
      id: id,
      description: description,
    );
  }
}
