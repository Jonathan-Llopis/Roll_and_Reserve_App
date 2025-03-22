import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';

class CardReserve extends StatefulWidget {
  const CardReserve({
    super.key,
    required this.reserve,
    required this.idShop,
  });

  final ReserveEntity reserve;
  final int idShop;

  @override
  State<CardReserve> createState() => _CardReserveState();
}

class _CardReserveState extends State<CardReserve> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      return buildContent<ShopState>(
        state: state,
        isLoading: (state) => state.isLoading,
        errorMessage: (state) => state.errorMessage,
        hasData: (state) => state.shops != null,
        context: context,
        contentBuilder: (state) {
          return BlocBuilder<TableBloc, TableState>(
            builder: (context, state) {
              return buildContent<TableState>(
                state: state,
                isLoading: (state) => state.isLoading,
                errorMessage: (state) => state.errorMessage,
                hasData: (state) =>
                    state.tables != null || state.tablesFromShop != null,
                context: context,
                contentBuilder: (state) {
                  late TableEntity table;
                  final shop = shopBloc.state.shops!
                      .firstWhere((shop) => shop.id == widget.idShop);
                  if (state.tables != null) {
                     table = state.tables!.firstWhere(
                        (table) => table.id == widget.reserve.tableId);
                  } else {
                     table = state.tablesFromShop!.firstWhere(
                        (table) => table.id == widget.reserve.tableId);
                  }

                  final game = reserveBloc.state.games!
                      .firstWhere((game) => game.id == widget.reserve.gameId);
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.dividerColor.withOpacity(0.2),
                            ),
                          ),
                          child: Container(
                            color: widget.reserve.isEvent
                                ? theme.colorScheme.tertiaryContainer
                                : theme.colorScheme.secondaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.reserve.isEvent
                                              ? loc.event_day_date(
                                                  widget.reserve.dayDate)
                                              : loc.reserve_day(
                                                  widget.reserve.dayDate),
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoRow(
                                      Icons.store, loc.shop_name(shop.name)),
                                  if (!widget.reserve.isEvent)
                                    _buildInfoRow(Icons.table_restaurant,
                                        loc.table_number(table.numberTable)),
                                  _buildInfoRow(Icons.sports_esports,
                                      loc.game_description(game.description)),
                                  if (!widget.reserve.isEvent)
                                    _buildInfoRow(
                                        Icons.people_alt,
                                        loc.total_players_at_table(
                                            widget.reserve.usersInTables,
                                            widget.reserve.freePlaces)),
                                  const SizedBox(height: 12),
                                  _buildTimeSection(theme, loc),
                                ],
                              ),
                            ),
                          )));
                },
              );
            },
          );
        },
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection(ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeChip(
            Icons.access_time_filled,
            loc.start_time(widget.reserve.horaInicio),
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: _buildTimeChip(
              Icons.timer_off, loc.end_time(widget.reserve.horaFin)),
        ),
      ],
    );
  }

  Widget _buildTimeChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
