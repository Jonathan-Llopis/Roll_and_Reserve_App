import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/domain/entities/table_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/screens/screen_tables_shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyTablesShop extends StatefulWidget {
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
  State<BodyTablesShop> createState() => _BodyTablesShopState();
}

class _BodyTablesShopState extends State<BodyTablesShop> {
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
                    widget.currentShop.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.rating,
                          style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      buildStars(widget.currentShop.averageRaiting),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.go('/user/shop/${widget.widget.idShop}/raiting/');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.storefront, size: 48, color: Colors.blueAccent),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.85,
                mainAxisExtent: 180,
              ),
              itemCount: widget.tables.length,
              itemBuilder: (context, index) {
                final table = widget.tables[index];
                return AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: 1.0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        widget.loginBloc.state.user!.role == 1
                            ? showUpdateCreateTableDialog(
                                context, widget.currentShop, table)
                            : context.go(
                                '/user/shop/${widget.widget.idShop}/table/${table.id}');
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Theme.of(context).colorScheme.surface,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.05),
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.05),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.table_restaurant,
                                      size: 48,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .table_number(table.numberTable),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
