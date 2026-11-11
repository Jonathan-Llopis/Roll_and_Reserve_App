import 'package:equatable/equatable.dart';

class GameCategoryEntity extends Equatable {
  final int id;
  final String description;

  const GameCategoryEntity({
    required this.id,
    required this.description,
  });

  GameCategoryEntity copyWith({
    int? id,
    String? description,
  }) {
    return GameCategoryEntity(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, description];
}
