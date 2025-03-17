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
