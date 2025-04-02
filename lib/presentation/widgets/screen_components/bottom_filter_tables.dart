import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_tables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/reserve/reserve_event.dart';

class BottomFilterTables extends StatefulWidget {
  const BottomFilterTables({
    required this.currentShop,
    required this.reserveBloc,
    required this.tableBloc,

    super.key,
  });
  final ShopEntity currentShop;
  final ReserveBloc reserveBloc;
  final TableBloc tableBloc;

  @override
  State<BottomFilterTables> createState() => _BottomFilterTablesState();
}

class _BottomFilterTablesState extends State<BottomFilterTables> {
  bool _isFilterApplied = false;

  @override
/// Initializes the state of the widget.
///
/// Checks if any filters are applied by accessing the [ReserveBloc] state
/// and updates the [_isFilterApplied] flag accordingly. This flag determines
/// the icon and color of the filter button in the bottom navigation bar.

  void initState() {
    super.initState();
    ReserveBloc reserveBloc = BlocProvider.of<ReserveBloc>(context);
    _isFilterApplied = reserveBloc.state.filterTables != null;
  }

  @override

  /// Builds the bottom navigation bar with the "Remove filters" and "Filter"
  /// buttons.
  ///
  /// The "Remove filters" button is used to remove any existing table filters
  /// and to fetch the tables from the backend. The "Filter" button is used to
  /// apply filters to the tables, and to show the filter dialog.
  ///
  /// The color of the "Filter" icon changes based on whether filters are
  /// currently applied or not. The color is blue if filters are applied,
  /// and grey if not.
  ///
  /// The state of the widget is updated whenever the user applies or removes
  /// filters.
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.delete_outline),
          label: AppLocalizations.of(context)!.remove_filters,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _isFilterApplied ? Icons.filter_alt : Icons.filter_list,
            color: _isFilterApplied ? Colors.blue : Colors.grey,
          ),
          label: AppLocalizations.of(context)!.filter_free_tables,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
        context.read<ReserveBloc>().add(ClearFilterEvent());
         widget.tableBloc.add(GetTablesByShopEvent(
                idShop: widget.currentShop.id,
              ));
          _isFilterApplied = false;
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterTables(
                currentShop: widget.currentShop, reserveBloc: widget.reserveBloc,  tableBloc: widget.tableBloc,
              );
            },
          );
          _isFilterApplied = true;
        }
      },
      currentIndex: 0,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
