import 'package:equatable/equatable.dart';

class GameEntity extends Equatable {
  final int id;
  final String description;
  final String? _name;
  final int? bggId;

  const GameEntity({
    required this.id,
    required this.description,
    String? name,
    this.bggId,
  }) : _name = name;

  String get name => _name ?? description;

  GameEntity copyWith({
    int? id,
    String? description,
    String? name,
    int? bggId,
  }) {
    return GameEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      name: name ?? _name,
      bggId: bggId ?? this.bggId,
    );
  }

  @override
  List<Object?> get props => [id, description, _name, bggId];
}
