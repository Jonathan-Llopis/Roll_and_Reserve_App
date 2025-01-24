import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_state.dart';
import 'package:roll_and_reserve/presentation/functions/state_check.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/default_scaffold.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/screen_body/body_edit_shop.dart';

class ScreenEditShop extends StatelessWidget {
  final int? idShop;
  const ScreenEditShop({super.key, this.idShop});

  @override
  Widget build(BuildContext context) {
    context.read<TableBloc>().add(GetTablesByShopEvent(idShop: idShop!));
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      return buildContent<TableState>(
          state: state,
          isLoading: (state) => state.isLoading,
          errorMessage: (state) => state.errorMessage,
          hasData: (state) => state.tables != null,
          contentBuilder: (state) {
            return DefaultScaffold(
                body: BodyEditShop(idShop: idShop, widget: this, state: state));
          });
    });
  }
}
