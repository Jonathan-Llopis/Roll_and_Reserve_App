import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_reserves_table.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

DateTime? _selectedDate;

class ScreenReservesOfTable extends StatefulWidget {
  final int idTable;
  final int idShop;
  const ScreenReservesOfTable(
      {super.key, required this.idTable, required this.idShop});

  @override
  State<ScreenReservesOfTable> createState() => _ScreenReservesOfTableState();
}

class _ScreenReservesOfTableState extends State<ScreenReservesOfTable> {
  late TableEntity table;

  @override
  void initState() {
    _selectedDate = DateTime.now();
    context.read<ReserveBloc>().add(
          GetReserveByDateEvent(
              dateReserve: _selectedDate!, idTable: widget.idTable),
        );
    TableBloc tableBloc = BlocProvider.of<TableBloc>(context);
    table = tableBloc.state.tablesFromShop!
        .firstWhere((table) => table.id == widget.idTable);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReserveBloc, ReserveState>(builder: (context, state) {
      return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.reserves != null,
          contentBuilder: (state) {
            return DefaultScaffold(body: BodyReservesTable(
              table: table,
              reserves: state.reserves!,
              selectedDate: _selectedDate!,
              idShop: widget.idShop,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.go('/user/shop/${widget.idShop}/table/${widget.idTable}/createReserve/${_selectedDate.toString()}');
              },
              child: const Icon(Icons.add),
            ),
            );
          });
    });
  }
}
