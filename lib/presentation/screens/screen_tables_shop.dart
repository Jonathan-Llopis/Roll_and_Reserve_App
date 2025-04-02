import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/login/login_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_state.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/functions_show_dialogs.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/bottom_filter_tables.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_tables_shop.dart';

class ScreenTablesOfShop extends StatefulWidget {
  final int idShop;

  final PreferredSizeWidget appBar;
  const ScreenTablesOfShop(
      {super.key, required this.idShop, required this.appBar});

  @override
  State<ScreenTablesOfShop> createState() => _ScreenTablesOfShopState();
}

class _ScreenTablesOfShopState extends State<ScreenTablesOfShop> {
  late ShopEntity currentShop;

  @override
  /// Called when the widget is inserted into the tree.
  ///
  /// This method is responsible for requesting the shop with the given idShop
  /// and all the tables of the shop from the database.
  ///
  void initState() {
    context.read<ShopBloc>().add(GetShopEvent(idShop: widget.idShop));
    context.read<ShopBloc>().add(GetShopsEvent());
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    super.initState();
  }

  @override
  /// Builds the screen with the tables of the shop.
  ///
  /// This screen is the default scaffold with the given [appBar] and a
  /// [BlocBuilder] that shows a [BodyTablesShop] if the [ShopState] has
  /// data, an error message if there is an error, and a
  /// [CircularProgressIndicator] if the state is loading.
  ///
  /// The [BodyTablesShop] is given the shop with the id of the shop,
  /// and the list of tables of the shop.
  ///
  /// The floating action button is a [FloatingActionButton] that leads to the
  /// table creation screen if the user is an admin, or to the table map
  /// screen if the user is a shop. For the shop, the bottom navigation bar is
  /// a [BottomFilterTables] that shows the filters of the tables of the shop.
  /// For the admin, the bottom navigation bar is null.
  ///
  Widget build(BuildContext context) {
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return DefaultScaffold(
      appBar: widget.appBar,
      body: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return buildContent<ShopState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.shop != null,
            context: context,
            contentBuilder: (state) {
              return BlocBuilder<TableBloc, TableState>(
                builder: (context, state) {
                  return buildContent<TableState>(
                    state: state,
                    isLoading: (state) => state.isLoading,
                    errorMessage: (state) => state.errorMessage,
                    hasData: (state) => state.tablesFromShop != null,
                    context: context,
                    contentBuilder: (state) {
                      currentShop = shopBloc.state.shop!;
                      return BodyTablesShop(
                          currentShop: currentShop,
                          widget: widget,
                          loginBloc: loginBloc,
                          tables: state.tablesFromShop!);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return buildContent<ShopState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.shop != null,
            context: context,
            contentBuilder: (state) {
              currentShop = shopBloc.state.shop!;
              return loginBloc.state.user!.role == 1
                  ? FloatingActionButton(
                      onPressed: () {
                        showUpdateCreateTableDialog(context, currentShop, null);
                      },
                      child: const Icon(Icons.add),
                    )
                  : Container();
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          return buildContent<ShopState>(
            state: state,
            isLoading: (state) => state.isLoading,
            errorMessage: (state) => state.errorMessage,
            hasData: (state) => state.shop != null,
            context: context,
            contentBuilder: (state) {
              currentShop = shopBloc.state.shop!;
              if (loginBloc.state.user!.role == 2) {
                return BottomFilterTables(
                  currentShop: currentShop,
                  reserveBloc: context.read<ReserveBloc>(),
                  tableBloc: context.read<TableBloc>(),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
