import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_shops.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomFilterShops extends StatefulWidget {
  final ShopBloc shopBloc;
  const BottomFilterShops({super.key, required this.shopBloc});

  @override
  State<BottomFilterShops> createState() => _BottomFilterShopsState();
}

class _BottomFilterShopsState extends State<BottomFilterShops> {
  bool _isFilterApplied = false;

  @override
  void initState() {
    super.initState();
    _checkFilterStatus();
  }

  Future<void> _checkFilterStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFilterApplied = prefs.getString('nombreTienda')?.isNotEmpty == true ||
          prefs.getString('localidadTienda')?.isNotEmpty == true;
    });
  }

  void _clearFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nombreTienda');
    await prefs.remove('localidadTienda');
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
          label: AppLocalizations.of(context)!.filter,
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          _clearFilters();
          widget.shopBloc.add(GetShopsEvent());
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterShops(shopBloc: widget.shopBloc);
            },
          ).then((_) {
            _checkFilterStatus();
          });
        }
      },
      currentIndex: 0,
    );
  }
}
