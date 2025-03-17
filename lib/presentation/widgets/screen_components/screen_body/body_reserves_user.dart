import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/reserve_entity.dart';
import 'package:roll_and_reserve/presentation/screens/screen_reserve.dart';
import 'package:roll_and_reserve/presentation/widgets/cards/card_reserve.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

DateTime? selectedDate;

class BodyReservesUser extends StatefulWidget {
  final List<ReserveEntity>? reserves;
  final PreferredSizeWidget appBar;
  const BodyReservesUser({
    super.key,
    this.reserves,
    required this.appBar,
  });

  @override
  State<BodyReservesUser> createState() => _BodyReservesUserState();
}

class _BodyReservesUserState extends State<BodyReservesUser> {
  @override
  Widget build(BuildContext context) {
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
                    AppLocalizations.of(context)!.your_reservations,
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
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.reserves?.length,
                itemBuilder: (context, index) {
                  final reserve = widget.reserves![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ScreenReserve(
                            idReserve: reserve.id,
                            idShop: reserve.shopId,
                            idTable: reserve.tableId,
                            appBar: widget.appBar,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: CardReserve(
                      reserve: reserve,
                      idShop: reserve.shopId!,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
