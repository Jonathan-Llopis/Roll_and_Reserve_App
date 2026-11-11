import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

sealed class EventState extends Equatable {
  final List<ReserveEntity>? events;
  final List<int>? createdEventIds;

  const EventState({
    this.events,
    this.createdEventIds,
  });

  bool get isLoading => this is EventLoading;
  String? get errorMessage =>
      this is EventFailure ? (this as EventFailure).message : null;

  EventState copyWith({
    List<ReserveEntity>? events,
    List<int>? createdEventIds,
  });

  @override
  List<Object?> get props => [events, createdEventIds];
}

class EventInitial extends EventState {
  const EventInitial() : super();

  @override
  EventState copyWith({
    List<ReserveEntity>? events,
    List<int>? createdEventIds,
  }) {
    return EventLoaded(
      events: events ?? this.events,
      createdEventIds: createdEventIds ?? this.createdEventIds,
    );
  }
}

class EventLoading extends EventState {
  const EventLoading({
    super.events,
    super.createdEventIds,
  });

  @override
  EventState copyWith({
    List<ReserveEntity>? events,
    List<int>? createdEventIds,
  }) {
    return EventLoading(
      events: events ?? this.events,
      createdEventIds: createdEventIds ?? this.createdEventIds,
    );
  }
}

class EventLoaded extends EventState {
  const EventLoaded({
    super.events,
    super.createdEventIds,
  });

  @override
  EventState copyWith({
    List<ReserveEntity>? events,
    List<int>? createdEventIds,
  }) {
    return EventLoaded(
      events: events ?? this.events,
      createdEventIds: createdEventIds ?? this.createdEventIds,
    );
  }
}

class EventFailure extends EventState {
  final String message;

  const EventFailure(
    this.message, {
    super.events,
    super.createdEventIds,
  });

  @override
  EventState copyWith({
    List<ReserveEntity>? events,
    List<int>? createdEventIds,
  }) {
    return EventFailure(
      message,
      events: events ?? this.events,
      createdEventIds: createdEventIds ?? this.createdEventIds,
    );
  }

  @override
  List<Object?> get props => [...super.props, message];
}
