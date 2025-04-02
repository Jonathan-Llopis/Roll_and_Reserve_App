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
import 'package:roll_and_reserve/presentation/functions/state_skeleton.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/chip_time.dart';

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
  /// Builds a card with information of a reserve.
  ///
  /// The card is divided in sections: date, shop, table, game, and time.
  /// Each section is composed of an icon, a title and a value. The value
  /// is obtained from the [ReserveBloc] and [ShopBloc] states.
  ///
  /// The date section shows the day and date of the reserve. If the reserve
  /// is an event, it shows the day and date in the format 'EEEE, dd-MM-yyyy'.
  /// Otherwise, it shows the day in the format 'EEEE'.
  ///
  /// The shop section shows the name of the shop that owns the reserve.
  ///
  /// The table section shows the number of the table that the reserve is
  /// associated with.
  ///
  /// The game section shows the description of the game that the reserve is
  /// associated with.
  ///
  /// The time section shows the start and end time of the reserve, and the
  /// remaining time until the reserve starts. If the reserve has already
  /// started, it shows the elapsed time since the reserve started.
  ///
  /// The card is colored differently depending on if the reserve is an event
  /// or not. If the reserve is an event, the card is colored with the
  /// secondary color. Otherwise, it is colored with the tertiary color.
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      return buildContentSkeleton<ShopState>(
        state: state,
        isLoading: (state) => state.isLoading,
        errorMessage: (state) => state.errorMessage,
        hasData: (state) => state.shops != null,
        context: context,
        contentBuilder: (state) {
          return BlocBuilder<TableBloc, TableState>(
            builder: (context, state) {
              return buildContentSkeleton<TableState>(
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
                            decoration: BoxDecoration(
                              color: widget.reserve.isEvent
                                ? theme.colorScheme.tertiaryContainer
                                : theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
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

  /// A horizontal row with an [Icon] and a [Text] widget.
  ///
  /// The [Icon] is given the [icon] parameter and the size is set to 18.
  /// The color of the [Icon] is set to grey[600].
  ///
  /// The [Text] is given the [text] parameter and the style is set to
  /// grey[800] with a font size of 14. The height of the text is set to 1.4.
  ///
  /// The two widgets are separated by a [SizedBox] with a width of 8.0.
  ///
  /// The [Padding] is set to have a symmetric vertical padding of 4.0.
  ///
  /// This is used in the [CardReserve] to display information about a reserve.
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

  /// A horizontal row with two [ChipTime] widgets.
  ///
  /// The first chip is given the [Icons.access_time_filled] icon and the
  /// start time of the reserve. The second chip is given the [Icons.timer_off]
  /// icon and the end time of the reserve.
  ///
  /// The two chips are separated by a [SizedBox] with a width of 5.0.
  ///
  /// The row is used in the [CardReserve] to display the start and end times
  /// of the reserve.
  Widget _buildTimeSection(ThemeData theme, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          child: buildTimeChip(
            Icons.access_time_filled,
            loc.start_time,
            widget.reserve.horaInicio,
          ),
        ),
        const SizedBox(width: 5.0),
        Expanded(
          child: buildTimeChip(
              Icons.timer_off, loc.end_time, widget.reserve.horaFin),
        ),
      ],
    );
  }
}
