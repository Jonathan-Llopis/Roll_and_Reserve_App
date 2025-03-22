import 'package:roll_and_reserve/domain/entities/table_entity.dart';

class TableState {
  final bool isLoading;
  final String? idTable;
  final String? errorMessage;
  final List<TableEntity>? tables;
  final List<TableEntity>? tablesFromShop;
  final TableEntity? table;
  final Map<String, String>? filterTables;

  const TableState(
      {this.isLoading = false,
      this.idTable,
      this.errorMessage,
      this.tables,
      this.table,
      this.tablesFromShop,
      this.filterTables});

  TableState copyWith(
      {bool? isLoading,
      String? idTable,
      String? errorMessage,
      List<TableEntity>? tables,
      List<TableEntity>? tablesFromShop,
      TableEntity? table,
      Map<String, String>? filterTables}) {
    return TableState(
        isLoading: isLoading ?? this.isLoading,
        idTable: idTable ?? this.idTable,
        errorMessage: errorMessage,
        tables: tables ?? this.tables,
        table: table ?? this.table,
        tablesFromShop: tablesFromShop ?? this.tablesFromShop,
        filterTables: filterTables ?? this.filterTables);
  }

  factory TableState.initial(TableState state) => state.copyWith();

  factory TableState.loading(TableState state) => state.copyWith(isLoading: true,errorMessage: null);

  factory TableState.success(TableState state) => state.copyWith(isLoading: false, errorMessage: null);

  factory TableState.getTables(TableState state, List<TableEntity> tables) =>
      state.copyWith(tables: tables,  isLoading: false, errorMessage: null);
      
  factory TableState.getTablesShop(TableState state, List<TableEntity> tables) =>
      state.copyWith(tablesFromShop: tables, isLoading: false, errorMessage: null);

  factory TableState.selectedTable(TableState state, TableEntity tableSelected) =>
      state.copyWith(table: tableSelected, isLoading: false, errorMessage: null);

  factory TableState.failure(TableState state, String errorMessage) =>
      state.copyWith(errorMessage: errorMessage, isLoading: false);
  
  factory TableState.filterTables(TableState state, Map<String, String> filterTables) =>
      state.copyWith(filterTables: filterTables, isLoading: false, errorMessage: null);
}
