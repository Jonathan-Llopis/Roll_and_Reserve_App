import 'package:flutter/material.dart';
import 'package:roll_and_reserve/domain/entities/shop_entity.dart';
import 'package:roll_and_reserve/presentation/blocs/reserve/reserve_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/tables/table_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_tables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  void initState() {
    super.initState();
    _checkFilterStatus();
  }

  Future<void> _checkFilterStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFilterApplied = prefs.getString('date')?.isNotEmpty == true ||
          prefs.getString('startTime')?.isNotEmpty == true;
      prefs.getString('endTime')?.isNotEmpty == true;
    });
  }

  void _clearFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('date');
    await prefs.remove('startTime');
    await prefs.remove('endTime');
    setState(() {
      _isFilterApplied = false;
    });
  }

  @override
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
          _clearFilters();
         widget.tableBloc.add(GetTablesByShopEvent(
                idShop: widget.currentShop.id,
              ));
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterTables(
                currentShop: widget.currentShop, reserveBloc: widget.reserveBloc,  tableBloc: widget.tableBloc,
              );
            },
          );
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
