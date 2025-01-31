import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_event.dart';

import 'package:roll_and_reserve/presentation/widgets/cards/card_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationReserve extends StatelessWidget {
  const InformationReserve({
    super.key,
    required this.reserve,
    required this.loginBloc,
    required this.dateReserve,
    required this.idShop,
  });

  final ReserveEntity reserve;
  final LoginBloc loginBloc;
  final DateTime dateReserve;
  final int idShop;

  @override
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
             reserve.isEvent ? Container() : Chip(
                label: Text(
                  AppLocalizations.of(context)!
                      .free_places(reserve.freePlaces - reserve.usersInTables),
                ),
                backgroundColor: Colors.blue.shade50,
              ),
            ],
          ),
          const SizedBox(height: 16),
          reserve.isEvent ? Container() : Text(
            AppLocalizations.of(context)!.players,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          reserve.isEvent ? Container() : Expanded(
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
              loginBloc.state.user!.role == 2 && !reserve.isEvent &&  DateFormat('dd - MM - yyyy HH:mm')
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
                                  searchDateTime: dateReserve
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
                  : reserve.isEvent
                        ? ElevatedButton.icon(
                          onPressed: () {
                            context.go(
                        '/user/events/$idShop/eventReserve/${reserve.id}');
                          },
                          icon: Icon(Icons.event),
                          label: Text(AppLocalizations.of(context)!.go_to_events),
                        )
                      : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
