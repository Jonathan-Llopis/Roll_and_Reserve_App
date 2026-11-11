import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final int id;
  final String description;

  const GameEntity({
    required this.id,
    required this.description,
  });

  GameEntity copyWith({
    int? id,
    String? description,
  }) {
    return GameEntity(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, description];
}
