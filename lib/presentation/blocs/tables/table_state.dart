import 'package:roll_and_reserve/domain/entities/table_entity.dart';

class TableState {
  final bool isLoading;
  final String? idTable;
  final String? errorMessage;
  final List<TableEntity>? tables;
  final TableEntity? table;

  const TableState(
      {this.isLoading = false,
      this.idTable,  
      this.errorMessage,
      this.tables,
      this.table
      });

  TableState copyWith({
    bool? isLoading,
    String? idTable,
    String? errorMessage,
    List<TableEntity>? tables,
    TableEntity? table
  }) {
    return TableState(
        isLoading: isLoading ?? this.isLoading,
        idTable: idTable ?? this.idTable,
        errorMessage: errorMessage ?? this.errorMessage,
        tables: tables ?? this.tables,
        table: table ?? this.table
        );
  }

    factory TableState.initial() => const TableState();

    factory TableState.loading() => const TableState(isLoading: true);

    factory TableState.success() => const TableState();

    factory TableState.getTables(List<TableEntity> tables) => TableState(tables: tables);

    factory TableState.selectedTable(TableEntity tableSelected) => TableState(table: tableSelected);

    factory TableState.failure(String errorMessage) =>
        TableState(errorMessage: errorMessage);

}
