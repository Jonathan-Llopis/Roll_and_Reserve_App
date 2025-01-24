import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

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
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        return buildContent<ReserveState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.reserves != null,
            contentBuilder: (state) {
              return DefaultScaffold(
                body: InformationReserve(
                    widget: widget,
                    reserve: state.reserve!,
                    loginBloc: loginBloc,
                    dateReserve:
                        DateFormat('dd - MM - yyyy').parse(state.reserve!.dayDate)),
              );
            });
      },
    );
  }
}
