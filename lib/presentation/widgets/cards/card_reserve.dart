import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserves_table.dart';


class CardReserve extends StatelessWidget {
  const CardReserve({
    super.key,
    required this.reserve,
    required this.widget,
  });

  final ReserveEntity reserve;
  final ReservationsScreen widget;

  @override
  Widget build(BuildContext context) {
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    return GestureDetector(
      onTap: () {
        context.go(
            '/user/shop/table/reserve/${reserve.id}${widget.idShop}');
      },
      child: Card(
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
                "Reserva: ${reserve.id}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Juego: ${reserveBloc.state.games!.firstWhere((game) => game.id == reserve.gameId).description}",
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              Text(
                "Total de jugadores en mesa: ${reserve.idUsers.length} de ${reserve.freePlaces}",
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              Text(
                "Hora de inicio: ${reserve.horaInicio}",
                style: const TextStyle(
                    fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 6),
              Text(
                "Hora de fin: ${reserve.horaFin}",
                style: const TextStyle(
                    fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
