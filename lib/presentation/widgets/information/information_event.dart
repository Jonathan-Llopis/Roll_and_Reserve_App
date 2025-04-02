import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';

import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationEvent extends StatelessWidget {
  const InformationEvent({
    super.key,
    required this.reserve,
    required this.loginBloc,
    required this.dateReserve,
  });

  final ReserveEntity reserve;
  final LoginBloc loginBloc;
  final DateTime dateReserve;

  @override
  /// Builds the UI for the information of an event.
  ///
  /// The widget is divided into three parts: a title with the name of the
  /// game, a section with the schedule of the event, and a section with the
  /// additional information of the event.
  ///
  /// The title is styled with [AppTheme.textButtonAcceptStyle].
  ///
  /// The schedule section shows the day, start time, and end time of the event.
  /// It also shows the number of free places of the event.
  ///
  /// The additional information section shows the description of the event.
  ///
  /// If the user is a shop owner, the widget also shows a button to add or
  /// remove the user from the event. If the user is already in the event, it
  /// shows a button to remove the user. If the user is not in the event, it
  /// shows a button to add the user. If the event has already started, the
  /// button is not shown.
  ///
  /// The widget is given the [ReserveEntity] of the event, the [LoginBloc],
  /// and the date and time of the event.
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reserve.isEvent
                ?  AppLocalizations.of(context)!.game_event(reserveBloc.state.games!.firstWhere((element) => element.id == reserve.gameId).description)
                : AppLocalizations.of(context)!.active_game(reserveBloc
                    .state.games!
                    .firstWhere((element) => element.id == reserve.gameId)
                    .description),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.schedule,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)!.day_schedule(
                        reserve.dayDate, reserve.horaInicio, reserve.horaFin),
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              Chip(
                label: Text(
                  AppLocalizations.of(context)!
                      .free_places(reserve.freePlaces - reserve.usersInTables),
                ),
                backgroundColor: Colors.blue.shade50,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.players,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: reserve.usersInTables,
              itemBuilder: (context, index) {
                final user = reserve.users![index];
                return CardUser(
                  user: user,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.additional_information,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reserve.description,
              style: TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              loginBloc.state.user!.role == 2 &&
                      DateFormat('dd - MM - yyyy HH:mm')
                          .parse('${reserve.dayDate} ${reserve.horaInicio}')
                          .isAfter(DateTime.now())
                  ? ElevatedButton.icon(
                      onPressed: () {
                        if (reserve.users!
                            .map((user) => user.id)
                            .contains(loginBloc.state.user!.id)) {
                          context
                              .read<ReserveBloc>()
                              .add(DeleteUserOfReserveEvent(
                                idReserve: reserve.id,
                                idUser: loginBloc.state.user!.id,
                                idTable: reserve.tableId,
                                dateReserve: dateReserve,
                              ));
                        } else {
                          if (reserve.users!.length < reserve.freePlaces) {
                            context
                                .read<ReserveBloc>()
                                .add(AddUserToReserveEvent(
                                  idReserve: reserve.id,
                                  idUser: loginBloc.state.user!.id,
                                  idTable: reserve.tableId,
                                  dateReserve: dateReserve,
                                  searchDateTime: DateTime.now()
                                ));
                          }
                        }
                      },
                      icon: Icon(
                        (reserve.users!
                                .map((user) => user.id)
                                .contains(loginBloc.state.user!.id))
                            ? Icons.logout
                            : Icons.login,
                      ),
                      label: Text(
                        (reserve.users!
                                .map((user) => user.id)
                                .contains(loginBloc.state.user!.id))
                            ? AppLocalizations.of(context)!.exit
                            : AppLocalizations.of(context)!.join,
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
