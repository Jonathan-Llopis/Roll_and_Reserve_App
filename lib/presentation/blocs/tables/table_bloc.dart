import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/create_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/delete_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/update_table_usecase.dart';

import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';

import '../../../domain/usecases/table_usecases/get_all_table_usecase.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final CreateTableUseCase createTablesUseCase;
  final GetAllTablesUseCase getTablesUseCase;
  final UpdateTableUseCase updateTablesUseCase;
  final DeleteTableUseCase deleteTablesUseCase;

  TableBloc(
    this.createTablesUseCase,
    this.getTablesUseCase,
    this.updateTablesUseCase,
    this.deleteTablesUseCase,
  ) : super(const TableState()) {
    on<GetTablesEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await getTablesUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(TableState.failure("Fallo al realizar la recuperacion")),
        (tables) => emit(TableState.getTables(tables)),
      );
    });
    on<GetTableEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await getTablesUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(TableState.failure("Fallo al realizar la recuperacion")),
        (tables) {
          final table = tables.firstWhere((table) => table.id == event.idTable);
          emit(TableState.selectedTable(table));
        },
      );
    });
    on<CreateTableEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await createTablesUseCase(event.table);
      result.fold(
        (failure) => emit(TableState.failure("Fallo al crear tienda")),
        (_) {
          emit(
            TableState.success(),
          );
          add(GetTablesByShopEvent( idShop: event.table.idShop));
        },
      );
    });
    on<UpdateTableEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await updateTablesUseCase(event.table);
      result.fold(
        (failure) => emit(TableState.failure("Fallo al actualizar tienda")),
        (_) {
          emit(
            TableState.success(),
          );
          add(GetTablesByShopEvent( idShop: event.table.idShop));
        },
      );
    });
    on<DeleteTableEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await deleteTablesUseCase(event.idTable);
      result.fold(
        (failure) => emit(TableState.failure("Fallo al eliminar tienda")),
        (_) {
          emit(
            TableState.success(),
          );
          add(GetTablesByShopEvent( idShop: event.idShop));
        },
      );
    });
   on<GetTablesByShopEvent>((event, emit) async {
     emit(TableState.loading());
     final result = await getTablesUseCase(NoParams());
     result.fold(
       (failure) =>
           emit(TableState.failure("Fallo al realizar la recuperacion")),
       (tables) {
         final tablesByOwner = tables.where((table) => table.idShop == event.idShop).toList();
         emit(TableState.getTables(tablesByOwner));
       },
     );
   });
  }
}
