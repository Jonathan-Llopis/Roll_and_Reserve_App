
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_bloc.dart';
import 'package:roll_and_reserve/presentation/blocs/shops/shop_event.dart';
import 'package:roll_and_reserve/presentation/widgets/screen_components/filter_shops.dart';

class BottomFilterShops extends StatelessWidget {
  const BottomFilterShops({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.delete_outline),
          label: 'Remove Filters',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.filter_list),
          label: 'Filter',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          context.read<ShopBloc>().add(GetShopsEvent(
               ));
        } else if (index == 1) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FilterShops();
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
