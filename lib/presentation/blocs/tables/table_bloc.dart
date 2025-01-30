import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:roll_and_reserve/core/use_case.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/create_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/delete_table_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/get_all_table_byshop_usecase.dart';
import 'package:roll_and_reserve/domain/usecases/table_usecases/update_table_usecase.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import '../../../domain/usecases/table_usecases/get_all_table_usecase.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final CreateTableUseCase createTablesUseCase;
  final GetAllTablesUseCase getTablesUseCase;
  final UpdateTableUseCase updateTablesUseCase;
  final DeleteTableUseCase deleteTablesUseCase;
  final GetAllTablesByShopUseCase getAllTablesByShopUseCase;

  TableBloc(
    this.createTablesUseCase,
    this.getTablesUseCase,
    this.updateTablesUseCase,
    this.deleteTablesUseCase,
    this.getAllTablesByShopUseCase
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
          add(GetTablesByShopEvent(idShop: event.table.idShop));
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
          add(GetTablesByShopEvent(idShop: event.table.idShop));
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
          add(GetTablesByShopEvent(idShop: event.idShop));
        },
      );
    });
    on<GetTablesByShopEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await getAllTablesByShopUseCase(GetTablesByShopUseCaseParams(idShop:event.idShop));
      result.fold(
        (failure) =>
            emit(TableState.failure("Fallo al realizar la recuperacion")),
        (tablesByShop) {
          emit(TableState.getTablesShop(tablesByShop));
        },
      );
    });
    on<GetAvailableTablesEvent>((event, emit) async {
      emit(TableState.loading());
      final result = await getTablesUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(TableState.failure("Falló al realizar la recuperación")),
        (tables) async {
          final availableTables = tables.where((table) {
            final tableOccupied = table.reserves.any((reserveId) {
              final reserveEntity =
                  event.reserves.firstWhereOrNull((r) => r.id == reserveId);
              if (reserveEntity == null) {
                return false;
              } else {
                final reserveStartDate = DateFormat('dd - MM - yyyy HH:mm')
                    .parse(
                        '${reserveEntity.dayDate} ${reserveEntity.horaInicio}');
                final reserveEndDate = DateFormat('dd - MM - yyyy HH:mm')
                    .parse('${reserveEntity.dayDate} ${reserveEntity.horaFin}');
                final eventStartDate = DateFormat('dd-MM-yyyy HH:mm').parse(
                    '${event.dayDate} ${event.startTime == '' ? '00:00' : event.startTime}');
                final eventEndDate = DateFormat('dd-MM-yyyy HH:mm').parse(
                    '${event.dayDate} ${event.endTime == '' ? '23:59' : event.endTime}');

                return !(reserveEndDate.isBefore(eventStartDate) ||
                    reserveStartDate.isAtSameMomentAs(eventEndDate) ||
                    reserveStartDate.isAfter(eventEndDate) ||
                    reserveEndDate.isAtSameMomentAs(eventStartDate));
              }
            });
            return !tableOccupied;
          }).toList();

          final shopTables = availableTables
              .where((table) => table.idShop == event.shopId)
              .toList();

           emit(TableState.getTablesShop(shopTables));
        },
      );
    });
  }
}
