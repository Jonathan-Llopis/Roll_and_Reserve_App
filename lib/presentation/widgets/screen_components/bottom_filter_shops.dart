import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_shops.dart';

class BottomFilterShops extends StatefulWidget {
  const BottomFilterShops({super.key});

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
          label: 'Remove Filters',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _isFilterApplied ? Icons.filter_alt : Icons.filter_list,
            color: _isFilterApplied ? Colors.blue : Colors.grey,
          ),
          label: 'Filter',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          _clearFilters();
          context.read<ShopBloc>().add(GetShopsEvent());
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterShops();
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
