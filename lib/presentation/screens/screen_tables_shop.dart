import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/widgets/default_app_bar.dart';
import 'package:roll_and_reserve/presentation/widgets/drawer_main.dart';

class TablesScreen extends StatefulWidget {
  final int idShop;
  const TablesScreen({super.key, required this.idShop});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late ShopEntity currentShop;

  @override
  void initState() {
    super.initState();
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    currentShop =
        shopBloc.state.shops!.firstWhere((shop) => shop.id == widget.idShop);
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.errorMessage != null) {
        return Center(child: Text(state.errorMessage!));
      } else if (state.tables != null) {
        LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBarDefault(scaffoldKey: scaffoldKey),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/user'),
                    ),
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
                          context.go('/user/shop/raiting/${widget.idShop}');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.storefront,
                                size: 48, color: Colors.blueAccent),
                            Text("Todas las Reseñas")
                          ],
                        )),
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
                                  context, widget.idShop, table)
                              : context.go(
                                  '/user/shop/table/${table.id}${widget.idShop}');
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Juego de la Mesa",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "${table.reserves.length} reservas",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
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
          endDrawer: const MenuLateral(),
          floatingActionButton: loginBloc.state.user!.role == 1
              ? FloatingActionButton(
                  onPressed: () {
                    showUpdateCreateTableDialog(context, widget.idShop, null);
                  },
                  child: const Icon(Icons.add),
                )
              : Container(),
        );
      }
      return Container();
    });
  }
}
