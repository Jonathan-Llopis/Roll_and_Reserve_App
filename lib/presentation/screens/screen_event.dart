import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/user_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/screens/screen_qr.dart';
import 'package:roll_and_reserve/presentation/widgets/information/information_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreenEvent extends StatefulWidget {
  final int idReserve;
  final int? idShop;

  final PreferredSizeWidget appBar;
  const ScreenEvent({
    super.key,
    required this.idReserve,
    this.idShop,
    required this.appBar,
  });

  @override
  State<ScreenEvent> createState() => _ScreenEventState();
}

class _ScreenEventState extends State<ScreenEvent> {
  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the tables and the reserve
  /// with users for the given idReserve from the database.
  void initState() {
    context.read<TableBloc>().add(GetTablesEvent());
    context
        .read<ReserveBloc>()
        .add(GetReserveWithUsers(idReserve: widget.idReserve));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
  /// Builds the content of the screen.
  ///
  /// The screen is divided into three parts: a [DefaultScaffold] with an
  /// [InformationEvent] as body, a [FloatingActionButton] if the user is a
  /// shop owner, and a [Text] with the reserve confirmation if the user is not
  /// a shop owner.
  ///
  /// The [FloatingActionButton] is only visible if the user is a shop owner,
  /// the reserve has not started yet, and the user has not confirmed the
  /// reserve. When pressed, it navigates to the [QRScannerScreen] with the
  /// idReserve, idShop, and idTable of the reserve and the appBar of the
  /// screen.
  ///
  /// The [Text] with the reserve confirmation is only visible if the user is
  /// not a shop owner. It shows the status of the reserve confirmation.
    return BlocBuilder<ReserveBloc, ReserveState>(
      builder: (context, state) {
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
              userReserve = state.reserve!.users!
                  .firstWhere((user) => user.id == loginBloc.state.user!.id);
            }
            return DefaultScaffold(
                appBar: widget.appBar,
                body: InformationEvent(
                  reserve: state.reserve!,
                  loginBloc: loginBloc,
                  dateReserve: DateFormat('dd - MM - yyyy')
                      .parse(state.reserve!.dayDate),
                ),
                floatingActionButton: loginBloc.state.user!.role == 2 &&
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
                              pageBuilder: (context, animation1, animation2) =>
                                  QRScannerScreen(
                                idReserve: widget.idReserve,
                                idShop: widget.idShop ?? 0,
                                idTable: state.reserve!.tableId,
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
                    : null);
          },
        );
      },
    );
  }
}
