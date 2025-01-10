
import 'package:roll_and_reserve/domain/entities/difficulty_entity.dart';

class DifficultyModel {
  final int id;
  final String description;

  DifficultyModel({
    required this.id,
    required this.description,
  });

  factory DifficultyModel.fromJson(Map<String, dynamic> json) {
    return DifficultyModel(
      id: json['id_difficulty'],
      description: json['description'],
    );
  }
  DifficultyEntity toDifficultyEntity() {
    return DifficultyEntity(
      id: id,
      description: description,
    );
  }
}
