import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';

sealed class PlayerState extends Equatable {
  final List<UserEntity>? lastUsers;
  final bool? operationSuccess;

  const PlayerState({
    this.lastUsers,
    this.operationSuccess,
  });

  bool get isLoading => this is PlayerLoading;
  String? get errorMessage =>
      this is PlayerFailure ? (this as PlayerFailure).message : null;

  PlayerState copyWith({
    List<UserEntity>? lastUsers,
    bool? operationSuccess,
  });

  @override
  List<Object?> get props => [lastUsers, operationSuccess];
}

class PlayerInitial extends PlayerState {
  const PlayerInitial() : super();

  @override
  PlayerState copyWith({
    List<UserEntity>? lastUsers,
    bool? operationSuccess,
  }) {
    return PlayerLoaded(
      lastUsers: lastUsers ?? this.lastUsers,
      operationSuccess: operationSuccess ?? this.operationSuccess,
    );
  }
}

class PlayerLoading extends PlayerState {
  const PlayerLoading({
    super.lastUsers,
    super.operationSuccess,
  });

  @override
  PlayerState copyWith({
    List<UserEntity>? lastUsers,
    bool? operationSuccess,
  }) {
    return PlayerLoading(
      lastUsers: lastUsers ?? this.lastUsers,
      operationSuccess: operationSuccess ?? this.operationSuccess,
    );
  }
}

class PlayerLoaded extends PlayerState {
  const PlayerLoaded({
    super.lastUsers,
    super.operationSuccess,
  });

  @override
  PlayerState copyWith({
    List<UserEntity>? lastUsers,
    bool? operationSuccess,
  }) {
    return PlayerLoaded(
      lastUsers: lastUsers ?? this.lastUsers,
      operationSuccess: operationSuccess ?? this.operationSuccess,
    );
  }
}

class PlayerFailure extends PlayerState {
  final String message;

  const PlayerFailure(
    this.message, {
    super.lastUsers,
    super.operationSuccess,
  });

  @override
  PlayerState copyWith({
    List<UserEntity>? lastUsers,
    bool? operationSuccess,
  }) {
    return PlayerFailure(
      message,
      lastUsers: lastUsers ?? this.lastUsers,
      operationSuccess: operationSuccess ?? this.operationSuccess,
    );
  }

  @override
  List<Object?> get props => [...super.props, message];
}
