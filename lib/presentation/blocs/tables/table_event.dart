import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

abstract class TableEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTablesEvent extends TableEvent {}

class GetTableEvent extends TableEvent {
  final int idTable;
  GetTableEvent({required this.idTable});

  @override
  List<Object?> get props => [idTable];
}

class CreateTableEvent extends TableEvent {
  final TableEntity table;
  CreateTableEvent({required this.table});

  @override
  List<Object?> get props => [table];
}

class UpdateTableEvent extends TableEvent {
  final TableEntity table;
  UpdateTableEvent({required this.table});

  @override
  List<Object?> get props => [table];
}

class DeleteTableEvent extends TableEvent {
  final int idTable;
  final int idShop;
  DeleteTableEvent({required this.idTable, required this.idShop});

  @override
  List<Object?> get props => [idTable];
}

class GetTablesByShopEvent extends TableEvent {
  final int idShop;
  GetTablesByShopEvent({required this.idShop});

  @override
  List<Object?> get props => [idShop];
}

class GetAvailableTablesEvent extends TableEvent {
  final String dayDate;
  final String startTime;
  final String endTime;
  final int shopId;
  final List<ReserveEntity> reserves;
  GetAvailableTablesEvent(
      {required this.dayDate,
      required this.startTime,
      required this.endTime,
      required this.reserves,
      required this.shopId,
  });

  @override
  List<Object?> get props => [dayDate, startTime, endTime, reserves, shopId];
}
