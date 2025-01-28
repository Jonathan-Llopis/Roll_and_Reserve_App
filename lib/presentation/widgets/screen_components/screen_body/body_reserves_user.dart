import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';

DateTime? selectedDate;

class BodyReservesUser extends StatefulWidget {
  final List<ReserveEntity>? reserves;
  const BodyReservesUser({
    super.key,
    this.reserves,
  });

  @override
  State<BodyReservesUser> createState() => _BodyReservesUserState();
}

class _BodyReservesUserState extends State<BodyReservesUser> {
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
                    "Tus Reservas",
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
              itemCount: widget.reserves?.length,
              itemBuilder: (context, index) {
                final reserve = widget.reserves![index];
                return  GestureDetector(
              onTap: () {
               
                context.go(
                    '/user/userReserves/gameReserve/${reserve.id}/${reserve.tableId}/${reserve.shopId}');
              }, child:  CardReserve(reserve: reserve, idShop: reserve.shopId!, shopState: shopBloc.state),);
              },
            ),
          ),
        ),
      ],
    );
  }
}
