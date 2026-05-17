import 'package:equatable/equatable.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';

sealed class TableState extends Equatable {
  final String? idTable;
  final List<TableEntity>? tables;
  final List<TableEntity>? tablesFromShop;
  final TableEntity? table;
  final Map<String, String>? filterTables;

  const TableState({
    this.idTable,
    this.tables,
    this.tablesFromShop,
    this.table,
    this.filterTables,
  });

  bool get isLoading => this is TableLoading;
  String? get errorMessage =>
      this is TableFailure ? (this as TableFailure).message : null;

  @override
  List<Object?> get props => [
        idTable,
        tables,
        tablesFromShop,
        table,
        filterTables,
      ];
}

class TableInitial extends TableState {
  const TableInitial() : super();
}

class TableLoading extends TableState {
  const TableLoading({
    super.idTable,
    super.tables,
    super.tablesFromShop,
    super.table,
    super.filterTables,
  });
}

class TableSuccess extends TableState {
  const TableSuccess({
    super.idTable,
    super.tables,
    super.tablesFromShop,
    super.table,
    super.filterTables,
  });
}

class TableFailure extends TableState {
  final String message;
  const TableFailure(
    this.message, {
    super.idTable,
    super.tables,
    super.tablesFromShop,
    super.table,
    super.filterTables,
  });

  @override
  List<Object?> get props => [super.props, message];
}
