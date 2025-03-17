import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/screens/screen_qr.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenReserve extends StatefulWidget {
  final int idReserve;
  final int? idShop;
  final int? idTable;

  final PreferredSizeWidget appBar;
  const ScreenReserve({
    super.key,
    required this.idReserve,
    this.idShop,
    this.idTable,
    required this.appBar,
  });

  @override
  State<ScreenReserve> createState() => _ScreenReserveState();
}

class _ScreenReserveState extends State<ScreenReserve> {
  late TableEntity table;

  @override
  void initState() {
    TableBloc tableBloc = BlocProvider.of<TableBloc>(context);
    table = tableBloc.state.tablesFromShop!
        .firstWhere((table) => table.id == widget.idTable);
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return DefaultScaffold(
        appBar: widget.appBar,
        body: BlocBuilder<ReserveBloc, ReserveState>(
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
              context: context,
              contentBuilder: (state) {
                return InformationReserve(
                  reserve: state.reserve!,
                  loginBloc: loginBloc,
                  dateReserve: DateFormat('dd - MM - yyyy')
                      .parse(state.reserve!.dayDate),
                  idShop: table.idShop,
                );
              },
            );
          },
        ),
        floatingActionButton: BlocBuilder<ReserveBloc, ReserveState>(
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
                context: context,
                contentBuilder: (state) {
                  UserEntity? userReserve;
                  if (state.reserve!.users!
                      .any((user) => user.id == loginBloc.state.user!.id)) {
                    userReserve = state.reserve!.users!.firstWhere(
                        (user) => user.id == loginBloc.state.user!.id);
                  }
                  return loginBloc.state.user!.role == 2 &&
                          !state.reserve!.isEvent &&
                          DateFormat('dd - MM - yyyy HH:mm')
                              .parse(
                                  '${state.reserve!.dayDate} ${state.reserve!.horaInicio}')
                              .subtract(Duration(minutes: 5))
                              .isBefore(DateTime.now()) &&
                          (userReserve?.reserveConfirmation ?? true) == false
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        QRScannerScreen(
                                  idReserve: widget.idReserve,
                                  idTable: widget.idTable!,
                                  idShop: table.idShop,
                                  appBar: widget.appBar,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code),
                              Text(AppLocalizations.of(context)!.confirm,
                                  style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        )
                      : SizedBox.shrink();
                });
          },
        ));
  }
}
