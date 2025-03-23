import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_reserves_table.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

DateTime? _selectedDate;

class ScreenReservesOfTable extends StatefulWidget {
  final int idTable;
  final int idShop;

  final PreferredSizeWidget appBar;
  const ScreenReservesOfTable(
      {super.key,
      required this.idTable,
      required this.idShop,
      required this.appBar});

  @override
  State<ScreenReservesOfTable> createState() => _ScreenReservesOfTableState();
}

class _ScreenReservesOfTableState extends State<ScreenReservesOfTable> {
  late TableEntity table;

  @override
  void initState() {
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    context.read<TableBloc>().add(GetTablesEvent());
    _selectedDate = reserveBloc.state.filterTables == null
        ? _selectedDate ?? DateTime.now()
        : DateFormat('yyyy-MM-dd')
            .parse(reserveBloc.state.filterTables!['dateReserve']!);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReserveBloc>().add(
            GetReserveByDateEvent(
                dateReserve: _selectedDate!, idTable: widget.idTable),
          );
      context
          .read<TableBloc>()
          .add(GetTablesByShopEvent(idShop: widget.idShop));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      appBar: widget.appBar,
      body: BlocBuilder<TableBloc, TableState>(builder: (context, state) {
        return buildContent<TableState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.tablesFromShop != null,
          context: context,
          contentBuilder: (state) {
            table = state.tablesFromShop!
                .firstWhere((table) => table.id == widget.idTable);
            return BodyReservesTable(
              table: table,
              selectedDate: _selectedDate!,
              idShop: widget.idShop,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(
              '/user/shop/${widget.idShop}/table/${widget.idTable}/createReserve/${_selectedDate.toString()}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
