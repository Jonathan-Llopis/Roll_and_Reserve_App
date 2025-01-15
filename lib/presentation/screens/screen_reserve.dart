import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_reserve.dart';

class ScreenReserve extends StatefulWidget {
  final int idReserve;
  final int idShop;
  final int idTable;
  const ScreenReserve({
    super.key,
    required this.idReserve,
    required this.idShop,
    required this.idTable,
  });

  @override
  State<ScreenReserve> createState() => _ScreenReserveState();
}

class _ScreenReserveState extends State<ScreenReserve> {

late TableEntity table;

@override
  void initState() {
    TableBloc tableBloc = BlocProvider.of<TableBloc>(context);
    table = tableBloc.state.tables!
        .firstWhere((table) => table.id == widget.idTable); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(state.errorMessage!)),
          );
        } else if (state.reserves != null) {
          ReserveEntity reserve = state.reserves!
              .firstWhere((reserve) => reserve.id == widget.idReserve);
          return Scaffold(
            appBar: AppBar(
              title: Text("Mesa: ${table.numberTable}"),
            ),
            body: InformationReserve(
                widget: widget,
                reserve: reserve,
                loginBloc: loginBloc,
                dateReserve:
                    DateFormat('dd - MM - yyyy').parse(reserve.dayDate)),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
