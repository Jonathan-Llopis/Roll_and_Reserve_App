import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';

class ScreenEvent extends StatefulWidget {
  final int idReserve;
  final int? idShop;
  const ScreenEvent({
    super.key,
    required this.idReserve,
    this.idShop,
  });

  @override
  State<ScreenEvent> createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEvent> {
  late TableEntity table;

  @override
  void initState() {
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    context.read<TableBloc>().add(GetTablesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    TableBloc tableBloc = BlocProvider.of<TableBloc>(context);
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
        if (state.reserve == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return buildContent<ReserveState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.reserve != null,
          contentBuilder: (state) {
            table = tableBloc.state.tables!
                .firstWhere((table) => table.id == state.reserve!.tableId);
            return DefaultScaffold(
                body: InformationEvent(
                  reserve: state.reserve!,
                  loginBloc: loginBloc,
                  dateReserve: DateFormat('dd - MM - yyyy')
                      .parse(state.reserve!.dayDate),
                ),
                floatingActionButton: loginBloc.state.user!.role == 2 &&
                        DateFormat('HH:mm')
                            .parse(state.reserve!.horaInicio)
                            .isAfter(DateTime.now())
                    ? FloatingActionButton(
                        onPressed: () {
                          context.go(
                              '/user/userReserves/gameReserve/${widget.idReserve}/${state.reserve!.tableId}/${table.idShop}/confirmationQR');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code),
                            Text('Confirmar', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      )
                    : null);
          },
        );
      },
    );
  }
}
