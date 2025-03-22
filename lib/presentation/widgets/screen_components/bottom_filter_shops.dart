import 'package:flutter/material.dart';
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
    _isFilterApplied = widget.shopBloc.state.filterShops != null;
    super.initState();
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
          widget.shopBloc.add(ClearFilterEvent());
          widget.shopBloc.add(GetShopsEvent());
          _isFilterApplied = false;
        } else if (index == 1) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: FilterShops(shopBloc: widget.shopBloc),
                );
              }).then((value) {
            setState(() {
              _isFilterApplied = widget.shopBloc.state.filterShops != null;
            });
          });
        }
      },
      currentIndex: 0,
    );
  }
}
