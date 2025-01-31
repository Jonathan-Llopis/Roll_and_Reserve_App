import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenReserve extends StatefulWidget {
  final int idReserve;
  final int? idShop;
  final int? idTable;
  const ScreenReserve({
    super.key,
    required this.idReserve,
    this.idShop,
    this.idTable,
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
          UserEntity? userReserve;
          if (state.reserve!.users!.any((user) => user.id == loginBloc.state.user!.id)) {
            userReserve = state.reserve!.users!
              .firstWhere((user) => user.id == loginBloc.state.user!.id);
          }
            return DefaultScaffold(
                body: InformationReserve(
                  reserve: state.reserve!,
                  loginBloc: loginBloc,
                  dateReserve: DateFormat('dd - MM - yyyy')
                      .parse(state.reserve!.dayDate),
                  idShop: table.idShop,
                ),
                floatingActionButton: loginBloc.state.user!.role == 2 &&
                        !state.reserve!.isEvent &&
                        DateFormat('dd - MM - yyyy HH:mm')
                          .parse('${state.reserve!.dayDate} ${state.reserve!.horaInicio}')
                            .subtract(Duration(minutes: 5))
                            .isBefore(DateTime.now()) && (userReserve?.reserveConfirmation ?? true) == false 
                    ? FloatingActionButton(
                        onPressed: () {
                          if (GoRouterState.of(context).uri.toString() ==
                              '/user/userReserves/gameReserve/${widget.idReserve}/${widget.idTable}/${table.idShop}/confirmationQR') {
                            context.go(
                                '/user/userReserves/gameReserve/${widget.idReserve}/${widget.idTable}/${table.idShop}/confirmationQR');
                          } else {
                            context.go(
                                '/user/shop/${table.idShop}/table/${widget.idTable}/reserve/${widget.idReserve}/confirmationQR');
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code),
                            Text(AppLocalizations.of(context)!.confirm, style: TextStyle(fontSize: 10)),
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
