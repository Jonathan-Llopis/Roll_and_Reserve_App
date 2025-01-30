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
  const ScreenTablesOfShop({super.key, required this.idShop});

  @override
  State<ScreenTablesOfShop> createState() => _ScreenTablesOfShopState();
}

class _ScreenTablesOfShopState extends State<ScreenTablesOfShop> {
  late ShopEntity currentShop;

  @override
  void initState() {
    context.read<ShopBloc>().add(GetShopEvent(idShop: widget.idShop));
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: widget.idShop));
    ShopBloc shopBloc = BlocProvider.of<ShopBloc>(context);
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        return buildContent<ShopState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.shop != null,
          contentBuilder: (state) {
            return BlocBuilder<TableBloc, TableState>(
              builder: (context, state) {
                return buildContent<TableState>(
                  state: state,
                  isLoading: (state) => state.isLoading,
                  errorMessage: (state) => state.errorMessage,
                  hasData: (state) => state.tablesFromShop != null,
                  contentBuilder: (state) {
                    currentShop = shopBloc.state.shop!;
                    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
                    return DefaultScaffold(
                      body: BodyTablesShop(
                          currentShop: currentShop,
                          widget: widget,
                          loginBloc: loginBloc,
                          tables: state.tablesFromShop!),
                      floatingActionButton: loginBloc.state.user!.role == 1
                          ? FloatingActionButton(
                              onPressed: () {
                                showUpdateCreateTableDialog(
                                    context, currentShop, null);
                              },
                              child: const Icon(Icons.add),
                            )
                          : Container(),
                      bottomNavigationBar: loginBloc.state.user!.role == 2
                          ? BottomFilterTables(
                              currentShop: currentShop,
                              reserveBloc: context.read<ReserveBloc>(),
                              tableBloc: context.read<TableBloc>(),
                            )
                          : null,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
