import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class GetShopEventsEvent extends EventEvent {
  final int idShop;

  const GetShopEventsEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class CreateShopEventEvent extends EventEvent {
  final List<ReserveEntity> reserves;

  const CreateShopEventEvent({required this.reserves});

  @override
  List<Object?> get props => [reserves];
}
