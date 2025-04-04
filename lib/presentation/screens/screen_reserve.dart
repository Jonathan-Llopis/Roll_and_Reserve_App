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
import 'package:roll_and_reserve/presentation/screens/screen_create_reserve.dart';
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
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the reserve with users for the
  /// given idReserve from the database, requesting all difficulty from the
  /// database, and requesting all games from the database.
  void initState() {
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    context.read<ReserveBloc>().add(GetAllDifficultyEvent());
    context.read<ReserveBloc>().add(GetAllGameEvent());
    super.initState();
  }

  @override
  /// Builds the screen with the information of the reserve with id [idReserve].
  ///
  /// The screen is divided into two parts: a [DefaultScaffold] with an
  /// [InformationReserve] as body, and a [FloatingActionButton].
  ///
  /// The [FloatingActionButton] is only visible if the user is a shop owner,
  /// the reserve has not started yet, and the user has not confirmed the
  /// reserve. When pressed, it navigates to the [QRScannerScreen] with the
  /// idReserve, idShop, and idTable of the reserve and the appBar of the
  /// screen.
  ///
  /// The [InformationReserve] is given the reserve with users, the
  /// [LoginBloc], the date and time of the reserve, and the idShop of the
  /// table.
  ///
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    TableBloc tableBloc = BlocProvider.of<TableBloc>(context);
    table = tableBloc.state.tables!
        .firstWhere((table) => table.id == widget.idTable);
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
                if (state.reserve!.id != widget.idReserve) {
                            return Center(
                            child: CircularProgressIndicator(),
                            );
                }
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
                              .isBefore(DateTime.now()) && DateFormat('dd - MM - yyyy HH:mm')
                              .parse(
                                  '${state.reserve!.dayDate} ${state.reserve!.horaFin}')
                              .subtract(Duration(minutes: 0))
                              .isAfter(DateTime.now()) &&
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
                      : state.reserve!.userReserveId == loginBloc.state.user!.id
                          ? FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            ScreenCreateReserve(
                                      idShop: table.idShop,
                                      idTable: widget.idTable!,
                                      appBar: widget.appBar,
                                      searchDateTimeString:
                                          '${state.reserve!.dayDate} ${state.reserve!.horaInicio}',
                                      reserve: state.reserve,
                                    ),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                              child: Icon(Icons.edit),
                            )
                          : SizedBox.shrink();
                });
          },
        ));
  }
}
