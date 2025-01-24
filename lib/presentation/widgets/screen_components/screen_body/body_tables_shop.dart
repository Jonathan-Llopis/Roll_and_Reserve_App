
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/screens/screen_tables_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyTablesShop extends StatelessWidget {
  const BodyTablesShop({
    super.key,
    required this.currentShop,
    required this.widget,
    required this.loginBloc,
    required this.tables,
  });

  final ShopEntity currentShop;
  final ScreenTablesOfShop widget;
  final LoginBloc loginBloc;
  final List<TableEntity> tables;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentShop.name,
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.rating,
                          style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      buildStars(currentShop.averageRaiting),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context
                      .go('/user/shop/${widget.idShop}/raiting/');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.storefront,
                        size: 48, color: Colors.blueAccent),
                    Text(AppLocalizations.of(context)!.all_reviews)
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.available_tables,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.9,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                return GestureDetector(
                  onTap: () {
                    loginBloc.state.user!.role == 1
                        ? showUpdateCreateTableDialog(
                            context, currentShop, table)
                        : context.go(
                            '/user/shop/${widget.idShop}/table/${table.id}');
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .table_number(table.numberTable),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
