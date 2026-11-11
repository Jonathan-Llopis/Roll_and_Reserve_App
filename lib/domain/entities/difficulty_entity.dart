import 'package:equatable/equatable.dart';

class DifficultyEntity extends Equatable {
  final int id;
  final String description;

  const DifficultyEntity({
    required this.id,
    required this.description,
  });

  DifficultyEntity copyWith({
    int? id,
    String? description,
  }) {
    return DifficultyEntity(
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, description];
}
