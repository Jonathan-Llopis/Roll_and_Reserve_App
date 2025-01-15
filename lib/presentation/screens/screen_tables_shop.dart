import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_utils.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/bottom_filter_tables.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/drawer_main.dart';

class ScreenTablesOfShop extends StatefulWidget {
  final int idShop;
  const ScreenTablesOfShop({super.key, required this.idShop});

  @override
  State<ScreenTablesOfShop> createState() => _ScreenTablesOfShopState();
}

class _ScreenTablesOfShopState extends State<ScreenTablesOfShop> {
  late ShopEntity currentShop;

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.tables != null) {
          currentShop = shopBloc.state.shops!
              .firstWhere((shop) => shop.id == widget.idShop);
          LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: DefaultAppBar(scaffoldKey: scaffoldKey, ),
            body: Column(
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
                              Text("Calificación:",
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(width: 8),
                              buildStars(currentShop.averageRaiting),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/user/shop/${widget.idShop}/raiting/');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront,
                                size: 48, color: Colors.blueAccent),
                            Text("Todas las Reseñas")
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
                    'Mesas Disponibles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: state.tables!.length,
                      itemBuilder: (context, index) {
                        final table = state.tables![index];
                        return GestureDetector(
                          onTap: () {
                            loginBloc.state.user!.role == 1
                                ? showUpdateCreateTableDialog(
                                    context,currentShop, table)
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
                                  "Mesa ${table.numberTable}",
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
            ),
            endDrawer: const DrawerMain(),
            floatingActionButton: loginBloc.state.user!.role == 1
                ? FloatingActionButton(
                    onPressed: () {
                      showUpdateCreateTableDialog(context, currentShop, null);
                    },
                    child: const Icon(Icons.add),
                  )
                : Container(),
            bottomNavigationBar: loginBloc.state.user!.role == 2
                ? BottomFilterTables(currentShop: currentShop)
                : null,
          );
        }
        return Container();
      },
    );
  }
}
