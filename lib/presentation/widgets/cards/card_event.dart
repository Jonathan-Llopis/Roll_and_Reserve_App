import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';

class CardEvent extends StatefulWidget {
  const CardEvent({
    super.key,
    required this.reserve,
    required this.idShop,
    required this.shopState,
  });

  final ReserveEntity reserve;
  final int idShop;
  final ShopState shopState;

  @override
  State<CardEvent> createState() => _CardEventState();
}

class _CardEventState extends State<CardEvent> {
  @override
  void initState() {
    context.read<TableBloc>().add(GetTablesEvent());
    context.read<ShopBloc>().add(GetShopsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
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
                hasData: (state) => state.tables != null,
                context: context,
                contentBuilder: (state) {
                  final shop = shopBloc.state.shops!
                      .firstWhere((shop) => shop.id == widget.idShop);
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .reserve_day(widget.reserve.dayDate),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!.shop_name(shop.name),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!.game_event(reserveBloc
                                .state.games!
                                .firstWhere(
                                    (game) => game.id == widget.reserve.gameId)
                                .description),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!
                                .start_time(widget.reserve.horaInicio),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppLocalizations.of(context)!
                                .end_time(widget.reserve.horaFin),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    });
  }
}
