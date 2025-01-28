import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_event.dart';

DateTime? selectedDate;

class BodyEvents extends StatefulWidget {
  final List<ReserveEntity>? events;
  final int idShop;
  const BodyEvents({
    super.key,
    this.events,
    required this.idShop,
  });

  @override
  State<BodyEvents> createState() => _BodyEventsState();
}

class _BodyEventsState extends State<BodyEvents> {
  @override
  Widget build(BuildContext context) {
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eventos de la Tienda",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: widget.events?.length,
              itemBuilder: (context, index) {
                final reserve = widget.events![index];
                return GestureDetector(
                  onTap: () {
                    context.go(
                        '/user/events/${widget.idShop}/eventReserve/${reserve.id}/${reserve.tableId}');
                  },
                  child: CardEvent(
                      reserve: reserve,
                      idShop: widget.idShop,
                      shopState: shopBloc.state),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
